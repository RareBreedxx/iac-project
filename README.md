# AWS Multi-Tier Infrastructure with Terraform

## Overview

This project provisions a production-style multi-tier AWS environment using Terraform.

All infrastructure components — networking, compute, and database — are defined as code following Infrastructure as Code (IaC) principles.

The architecture separates the public application layer from the private database layer, enforcing security and scalability best practices commonly used in real-world DevOps environments.

---

## Architecture

```
                        Internet
                            |
                    Internet Gateway
                            |
                     VPC (10.0.0.0/16)
                            |
        ------------------------------------------------
        |                                              |
 Public Subnet (10.0.1.0/24)              Private Subnet A (10.0.2.0/24)
   |                                      Private Subnet B (10.0.3.0/24)
   |                                              |
   |-- EC2 Instance 1                             |-- RDS MySQL Instance
   |-- EC2 Instance 2                             |   (Not publicly accessible)
```

---

## Design Rationale

This infrastructure follows a multi-tier architecture pattern:

* Public subnet hosts application servers (EC2)
* Private subnets isolate the database layer (RDS)
* Security groups enforce least-privilege access between tiers
* Database is not exposed to the public internet

This design improves:

* security
* separation of concerns
* maintainability
* scalability

---

## AWS Region

All resources are deployed in:

```
us-east-2
```

---

## Resources Provisioned

* 1 VPC
* 1 Public Subnet
* 2 Private Subnets
* 1 Internet Gateway
* 1 Route Table and Association
* 2 EC2 Instances (Application Tier)
* 1 RDS MySQL Instance (Database Tier)
* 1 DB Subnet Group
* 2 Security Groups
* Terraform Outputs

---

## Project Structure

```
main.tf
network.tf
security.tf
ec2.tf
rds.tf
variables.tf
terraform.tfvars (ignored)
outputs.tf
README.md
.gitignore
```

---

## Prerequisites

Ensure the following are installed and configured:

* AWS Account
* Terraform
* AWS CLI

Configure AWS CLI:

```bash
aws configure
```

Required:

* Access Key
* Secret Key
* Region: us-east-2
* Output: json

Also ensure:

* EC2 Key Pair exists in the same region

---

## Configuration

This project uses variables to avoid hardcoding values.

Sensitive values (like database passwords) are stored in:

```
terraform.tfvars
```

This file is excluded from version control.

---

## Deployment Workflow

### Initialize Terraform

```bash
terraform init
```

### Format Code

```bash
terraform fmt
```

### Validate Configuration

```bash
terraform validate
```

### Preview Deployment

```bash
terraform plan
```

### Apply Infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

---

## Outputs

Retrieve deployment outputs:

```bash
terraform output
```

Examples:

* web1_public_ip
* web2_public_ip
* rds_endpoint
* vpc_id

---

## SSH Access

```bash
ssh -i ~/iac-key.pem ec2-user@<WEB1_PUBLIC_IP>
```

---

## Validate RDS Connectivity

### Step 1 — SSH into EC2

```bash
ssh -i ~/iac-key.pem ec2-user@<WEB1_PUBLIC_IP>
```

### Step 2 — Install MySQL Client

```bash
sudo dnf install mariadb105 -y
```

### Step 3 — Connect to RDS

```bash
mysql -h <RDS_ENDPOINT> -u admin -p
```

Optional with port:

```bash
mysql -h <RDS_ENDPOINT> -P 3306 -u admin -p
```

Successful connection confirms:

* EC2 can reach RDS
* RDS is private
* Security groups are correctly configured

---

## Security Model

### EC2 Security Group

Allows:

* SSH (22)
* HTTP (80)
* HTTPS (443)

### RDS Security Group

Allows:

* MySQL (3306) ONLY from EC2 security group

### Security Notes

* RDS is not publicly accessible
* Database is deployed in private subnets
* Secrets are not stored in Git
* terraform.tfvars is ignored

---

## Production Practices Implemented

* Infrastructure as Code (IaC)
* Variable-driven configuration
* Multi-tier architecture
* Private database deployment
* Security group isolation
* Clean file separation by responsibility
* Reproducible deployments
* Safe teardown capability

---

## Troubleshooting

### EC2 Key Pair Not Found

Ensure key exists in the same region as Terraform.

### Invalid Subnet ID

Likely caused by region mismatch or stale state.

### Instance Type Not Allowed

Use a valid free-tier instance (e.g., t3.micro).

### RDS Connection Failure

Check:

* endpoint
* credentials
* security group rules
* RDS status

### SSH Issues

Ensure:

```bash
chmod 400 ~/iac-key.pem
```

---

## Destroy Infrastructure

To avoid AWS charges:

```bash
terraform destroy
```

---

## Future Improvements

To make this closer to production:

* Application Load Balancer
* Auto Scaling Group
* NAT Gateway
* Remote Terraform state (S3 + DynamoDB)
* Terraform modules
* IAM roles
* CloudWatch monitoring
* CI/CD pipeline (GitHub Actions / Jenkins)
* Route 53 DNS
* HTTPS with ACM
* Bastion host or SSM access
* Multi-environment setup (dev/stage/prod)

---

## Conclusion

This project demonstrates how to provision a secure, structured AWS environment using Terraform.

It includes a public application tier, a private database tier, controlled access between components, and validation steps — reflecting real-world cloud infrastructure engineering practices.
