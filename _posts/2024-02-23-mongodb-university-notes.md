## creating and deploying an atlas cluster

```
$ atlas auth login
$ atlas setup --clusterName myAtlasClusterEDU --provider AWS --currentIp --skipSampleData --username myAtlasDBUser --password myatlas-001 | tee atlas_cluster_details.txt

$ atlas clusters sampleData load myAtlasClusterEDU

```

## Self-Managed Database Security

- https://learn.mongodb.com/learn/course/mongodb-self-managed-database-security/lesson-1-introduction-to-security/learn

### Lesson 1: Introduction to Security:

- Authentication
  - Verify identity
  - Human
  - Software service
  - Methods
    - Prompting user for user and password
    - Integrated IDP
- Authorization
  - Limit what authenticated user can access
  - Roll-Based
- Auditing
  - Audit DB
  - Purpose
    - Regulatory requirement
    - Security incident

### Lesson 2: Enabling Authentication for a Self-Managed MongoDB Deployment

- SCRAM - Salted Challenge Response Authentication Mechanism. Default authentication method.

```
vi /etc/mondod.conf
```

```
security:
  authorization: enabled
```

```
mongod --config /etc/mongod.conf
```

```
mongosh localhost:27017/admin
> use admin
> db.createUser(...)
> db.getUsers()
```

### Lesson 3: Establishing Authorization for a Self-Managed MongoDB Deployment

https://learn.mongodb.com/learn/course/mongodb-self-managed-database-security/lesson-3-establishing-authorization-for-a-self-managed-mongodb-deployment/learn?client=customer&page=2

- builtin rolls

```
db.createUser(
    {
        user: "financeUser",
        pwd: passwordPrompt(),
        roles: [
            { role: "readWrite", db: "sample_analytics" },
            { role: "read", db: "sample_supplies" }
        ]
    }
)
```

```
mongosh "mongodb://analyst@localhost:27017/sample_analytics?authSource=admin"
```

```
db.revokeRolesFromUser(
    "financeUser",
    [
        {
            role: "read",
            db: "sample_supplies"
        }
    ]
)
```

mongosh localhost:27017/admin --username globalUserAdmin

### Lesson 4: Security Auditing in MongoDB

https://learn.mongodb.com/learn/course/mongodb-self-managed-database-security/lesson-4-security-auditing-in-mongodb/learn?client=customer&page=2

- Location of the audit log file can be found in `/etc/mondod.conf` under `auditLog` section.
- tail the log. Use `jq` for pretty print. `sudo tail /var/log/mongodb/auditLog.json | jq`

### Lesson 5

- Encryption at-rest (Encypted Storage Engine - native)
- Encryption during transfer (TLS)
- Encryption in-use and at-rest (CSFLE - Clinet-Side Field Level Encryptions)

### Lesson 7: Enabling Network Encryption for a Self-Managed MongoDB Deployment

TLS certificate for each server in a deployment to enable TLS in a self-managed environment. You also learned that the `net.tls.mode` configuration file setting must be set to `requireTLS` to specify that a server uses and accepts only TLS-encrypted connections.

https://learn.mongodb.com/learn/course/mongodb-self-managed-database-security/lesson-7-enabling-network-encryption-for-a-self-managed-mongodb-deployment/learn?client=customer&page=2

- TLS in `.pem` file format
- In prod use certificate signed by CA.

### Questions

- What authentication are you using?
- Why or why not to use integrated IDP?
- Is Auditing enabled by default?
- How to enable and how to monitor the auditing events?
- How often do you review the audit report?
- Who is incharge of reviewing the audit? There is no value if it is not planned to do.
- Did you enable encryption at-rest, in-transit and in-use?

## MongoDB Atlas Security

### Lesson 1: Intro

https://learn.mongodb.com/learn/course/mongodb-atlas-security/lesson-1-introduction-to-security/learn

- Authentication
- Authorization
- Auditing
  - to analyze security incidents
  - for complaince purpose

### Lesson 2: The Atlas User Management Model

- Atlas User
  - Responsible for managing
    - Organization
    - Projects
    - Database Users
    - Billing
  - Built-In Roles
    - Project Owner
    - Project Cluster Manager
    - Project Data Access Admin
    - Project Data Access Read/Write
    - Project Data Access Read Only
- Database User
  - Authentication
    - SCRAM
    - X.509
    - AWS IAM
  - Built-In Roles
    - atlasAdmin
    - readWriteAnyDatabase
    - readAnyDatabase

### Lesson 3: Atlas User Management

- Atlas provides hierarchy of access
- provides multi-factor authentication (MFA)

#### CLI Commands

```
atlas projects list --orgID 1234
atlas projects organizations invitations invite ...
atlas projects users list
atlas projects user delete ...
```

https://learn.mongodb.com/learn/course/mongodb-atlas-security/lesson-3-atlas-user-management/learn?client=customer&page=2

```
root@mongodb:~$ atlas projects invitations invite test.user@mongodb.com --role GROUP_READ_ONLY
root@mongodb:~$ atlas projects invitations list
ID                         USERNAME                CREATED AT                      EXPIRES AT
65dc68f235aac70ddc602409   test.user@mongodb.com   2024-02-26 10:33:22 +0000 UTC   2024-03-27 10:33:22 +0000 UTC
root@mongodb:~$ atlas organizations invitations list --orgId 1234567890
ID                         USERNAME                CREATED AT                      EXPIRES AT
65dc68f235aac70ddc602409   test.user@mongodb.com   2024-02-26 10:33:22 +0000 UTC   2024-03-27 10:33:22 +0000 UTC
root@mongodb:~$ atlas project invitations delete 65dc68f235aac70ddc602409
? Are you sure you want to delete: 65dc68f235aac70ddc602409 Yes
Invitation '65dc68f235aac70ddc602409' deleted
root@mongodb:~$ atlas organizations invitations list --orgId 1234567890
ID    USERNAME   CREATED AT   EXPIRES AT
```

### Questions

- How often do you review/audit the principle of least privilege
- Are you using the expiring access for your higher environments?
