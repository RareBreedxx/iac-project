# AWS Infrastructure as Code (Terraform)

## Overview

This project provisions a multi-tier AWS infrastructure using Terraform.
All resources — networking, compute, and database — are defined as code, following Infrastructure as Code (IaC) principles.

The architecture simulates a real-world cloud environment with a public application tier and a private database tier.

---

## Architecture

```
                Internet
                    |
             Internet Gateway
                    |
              VPC (10.0.0.0/16)
                    |
     ---------------------------------
     |                               |
Public Subnet                  Private Subnets
(10.0.1.0/24)         (10.0.2.0/24, 10.0.3.0/24)
     |                               |
  EC2 Instance 1                 RDS MySQL
  EC2 Instance 2              (Not Publicly Accessible)
```

---

## Resources Created

* 1 VPC
* 1 Public Subnet
* 2 Private Subnets (multi-AZ)
* 2 EC2 Instances (Application Tier)
* 1 RDS MySQL Instance (Database Tier)
* Security Groups for controlled access
* Internet Gateway and Route Table

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
```

---

## Prerequisites

* AWS Account
* AWS CLI installed and configured:

  ```bash
  aws configure
  ```
* Terraform installed
* Existing AWS EC2 Key Pair in the target region (e.g., `iac-key`)

---

## Deployment Steps

### Initialize Terraform

```bash
terraform init
```

### Format and Validate

```bash
terraform fmt
terraform validate
```

### Preview Infrastructure

```bash
terraform plan
```

### Deploy Infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

---

## Outputs

After deployment:

```bash
terraform output
```

Example outputs:

* EC2 public IP addresses
* RDS endpoint

---

## SSH into EC2

```bash
ssh -i ~/iac-key.pem ec2-user@<WEB1_PUBLIC_IP>
```

---

## Test RDS Connectivity from EC2

SSH into one of the EC2 instances, then install MySQL client:

```bash
sudo dnf install mariadb105 -y
```

Connect to the database:

```bash
mysql -h <RDS_ENDPOINT> -u admin -p
```

If specifying port explicitly:

```bash
mysql -h <RDS_ENDPOINT> -P 3306 -u admin -p
```

Successful connection confirms:

* EC2 can communicate with RDS
* RDS is private and not publicly accessible
* Security groups are correctly configured

---

## Security Design

* EC2 Security Group:

  * Allows SSH (22), HTTP (80), HTTPS (443) from the internet

* RDS Security Group:

  * Allows MySQL (3306) only from EC2 security group

* RDS:

  * Deployed in private subnets
  * Not publicly accessible

---

## Destroy Infrastructure

To avoid AWS charges:

```bash
terraform destroy
```

Type `yes` when prompted.

---

## Notes

* Sensitive values (e.g., database password) are stored in variables and not committed to Git
* Infrastructure is modular and follows best practices for Terraform structure
* This project reflects a basic multi-tier cloud architecture used in real-world DevOps environments
