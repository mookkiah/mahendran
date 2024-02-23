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
