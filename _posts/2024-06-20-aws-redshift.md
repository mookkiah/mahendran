---
layout: post
title: "AWS Redshift"
date: 2024-06-20 06:54:00 -0400
modified_date: 2024-09-11 18:49:00 -0400
categories: aws redshift
---

## Practice cluster snapshot, pause, delete and restore

### Useful AWS commands

To list all manual and automated Redshift snapshots created in the last 30 days:

```sh
aws redshift describe-cluster-snapshots \
  --snapshot-type manual \
  --start-time $(date -v-365d +"%Y-%m-%dT%H:%M:%S")
```

To limit few fiels with jq

```sh
aws redshift describe-cluster-snapshots | jq ".Snapshots[] | {SnapshotIdentifier, ClusterIdentifier, SnapshotCreateTime, SnapshotType, TotalBackupSizeInMegaBytes, ManualSnapshotRetentionPeriod}"
```

List snapshots without retention period

```sh
$ aws redshift describe-cluster-snapshots --snapshot-type manual,automated --no-retention-period
```

`--no-retention-period` is **NOT** working as Amazon Q explains or unofficial blog posts. It is not implemented

```sh
$ aws redshift describe-cluster-snapshots --snapshot-type manual  | jq  ".Snapshots |= map(select (.ManualSnapshotRetentionPeriod == -1))" | jq ".Snapshots[] | {SnapshotIdentifier, ClusterIdentifier, SnapshotCreateTime, SnapshotType, TotalBackupSizeInMegaBytes, ManualSnapshotRetentionPeriod}"
```

To view snapshot schedules

```
$ aws redshift describe-snapshot-schedules
```

### Create cluster

Node Types

- economic - `dc2.large`
- Production - choose any `ra3`

```sh
aws redshift describe-clusters | jq ".Clusters[] |= {ClusterIdentifier,NodeType, ClusterStatus }"
```

### Backup & Snapshots

Before making any infrastructure or DBA kind changes, it is recommended to take backup.

```sh
aws redshift create-cluster-snapshot --cluster-identifier <cluster-name> --snapshot-identifier <snapshot-name> [--snapshot-cluster-identifier <cluster-name>]
aws redshift create-cluster-snapshot --cluster-identifier myredshift-sandbox --snapshot-identifier myredshift-sandbox-001
```

### Sample Queries

```sql
create table driver (name VARCHAR, age integer, candrivecar boolean);
insert into driver values ('Mahendran', 55, true);
```

Manipulate sample DB

```sql
select * from users limit 10
delete from users where username = 'AEB55QTM'
select * from users where username = 'AEB55QTM'

```

```sh
aws redshift create-cluster-snapshot --cluster-identifier myredshift-sandbox --snapshot-identifier myredshift-sandbox-after-change

```

### Pause Cluster

```sh
$ aws redshift pause-cluster --cluster-identifier <cluster-name>
$ aws redshift pause-cluster --cluster-identifier myredshift-sandbox
$ aws redshift describe-clusters | jq ".Clusters[] |= {ClusterIdentifier,NodeType, ClusterStatus }"
{
  "Clusters": [
    {
      "ClusterIdentifier": "myredshift-sandbox",
      "NodeType": "dc2.large",
      "ClusterStatus": "pausing"
    }
  ]
}
$ aws redshift describe-clusters | jq ".Clusters[] |= {ClusterIdentifier,NodeType, ClusterStatus }"
{
  "Clusters": [
    {
      "ClusterIdentifier": "myredshift-sandbox",
      "NodeType": "dc2.large",
      "ClusterStatus": "paused"
    }
  ]
}
```

### Describe Events for activity monitoring

```sh
$ aws redshift describe-events --source-identifier myredshift-sandbox --source-type cluster
```

### Resume cluster

```sh
$ aws redshift resume-cluster --cluster-identifier <cluster-name>
$ aws redshift resume-cluster --cluster-identifier myredshift-sandbox
$ aws redshift describe-clusters | jq ".Clusters[] |= {ClusterIdentifier,NodeType, ClusterStatus }"
{
  "Clusters": [
    {
      "ClusterIdentifier": "myredshift-sandbox",
      "NodeType": "dc2.large",
      "ClusterStatus": "resuming"
    }
  ]
}
$ aws redshift describe-clusters | jq ".Clusters[] |= {ClusterIdentifier,NodeType, ClusterStatus }"
{
  "Clusters": [
    {
      "ClusterIdentifier": "myredshift-sandbox",
      "NodeType": "dc2.large",
      "ClusterStatus": "available"
    }
  ]
}
```

### Delete cluster

Delete cluster using console to confirm after reviewing.
Paused cluster can be deleted;
Create final snapshot to avoid data loss.

```sh
$ aws redshift describe-cluster-snapshots --snapshot-type manual  | jq  ".Snapshots |= map(select (.ManualSnapshotRetentionPeriod == -1))" | jq ".Snapshots[] | {SnapshotIdentifier, ClusterIdentifier, SnapshotCreateTime, SnapshotType, TotalBackupSizeInMegaBytes, ManualSnapshotRetentionPeriod}"
{
  "SnapshotIdentifier": "myredshift-sandbox-final-snapshot",
  "ClusterIdentifier": "myredshift-sandbox",
  "SnapshotCreateTime": "2024-08-26T22:19:17.623000+00:00",
  "SnapshotType": "manual",
  "TotalBackupSizeInMegaBytes": 4206,
  "ManualSnapshotRetentionPeriod": -1
}
{
  "SnapshotIdentifier": "myredshift-sandbox-after-change",
  "ClusterIdentifier": "myredshift-sandbox",
  "SnapshotCreateTime": "2024-08-26T21:59:49.967000+00:00",
  "SnapshotType": "manual",
  "TotalBackupSizeInMegaBytes": 3931,
  "ManualSnapshotRetentionPeriod": -1
}
{
  "SnapshotIdentifier": "myredshift-sandbox-001",
  "ClusterIdentifier": "myredshift-sandbox",
  "SnapshotCreateTime": "2024-08-26T21:45:05.894000+00:00",
  "SnapshotType": "manual",
  "TotalBackupSizeInMegaBytes": 707,
  "ManualSnapshotRetentionPeriod": -1
}
```

### Restore from snapshot

```sh
$ aws redshift restore-from-cluster-snapshot \
    --snapshot-identifier myredshift-sandbox-final-snapshot \
    --cluster-identifier myredshift-sandbox-new \
    --node-type dc2.large \
    --allow-version-upgrade
$ aws redshift describe-clusters | jq ".Clusters[] |= {ClusterIdentifier,NodeType, ClusterStatus }"
{
  "Clusters": [
    {
      "ClusterIdentifier": "myredshift-sandbox-new",
      "NodeType": "dc2.large",
      "ClusterStatus": "creating"
    }
  ]
}
```

While restoring from snapshot, we can change the cluster configuration. To find what options available...

```sh
aws redshift describe-node-configuration-options --snapshot-identifier myredshift-sandbox-final-snapshot --region eu-west-1 --action-type restore-cluster
```

```sh
$ aws redshift restore-from-cluster-snapshot --snapshot-identifier as-is-as-of-aug-23 --cluster-identifier mysandbox-3 --node-type dc2.large --allow-version-upgrade

An error occurred (InvalidSubnet) when calling the RestoreFromClusterSnapshot operation: No default subnet detected in VPC. Please contact AWS Support to recreate default Subnets.
```

## Internet accessible

To make/block the cluster accessible from internet (outside VPC), change the cluster `properties` --> `Network and security settings`
--> `Publicly accessible` settings

To make/block the serverless workgroup accessible from internet (outside VPC), go to your workgroup and edit `Data access` --> `Publicly accessible` settings

## Create user and grant access

```sql
select * from pg_user;
CREATE USER awsdbuser WITH PASSWORD 'YourSecurePassword';
GRANT ROLE sys:dba TO awsdbuser;
GRANT ROLE sys:superuser TO awsdbuser;
select * from pg_user;
```

## Resources

- https://docs.aws.amazon.com/cli/latest/reference/redshift/
- https://docs.aws.amazon.com/redshift/latest/dg/r_GRANT-examples.html
