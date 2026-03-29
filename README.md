# AWS Multi-Tier Infrastructure with Terraform

## Overview

This project provisions a production-style AWS infrastructure using Terraform.

It implements a multi-tier architecture with a public application layer and a private database layer, along with a load balancer and CI validation workflow.

---

## Architecture

```
Internet
   |
Application Load Balancer
   |
-------------------------------
|                             |
EC2 Instance 1           EC2 Instance 2
(Public Subnet A)        (Public Subnet B)
        |
        |
   Private Subnets
        |
   RDS MySQL (Private)
```

---

## Key Features

* Infrastructure as Code (Terraform)
* Custom VPC with public and private subnets
* EC2 instances deployed across multiple Availability Zones
* Private RDS MySQL database
* Application Load Balancer for traffic distribution
* Security group isolation between tiers
* GitHub Actions CI for Terraform validation

---

## AWS Region

```
us-east-2
```

---

## Resources Provisioned

* VPC
* 2 Public Subnets
* 2 Private Subnets
* Internet Gateway
* Route Tables
* 2 EC2 Instances
* RDS MySQL Instance
* Application Load Balancer
* Target Group & Listener
* Security Groups

---

## CI/CD (GitHub Actions)

On every push:

* terraform fmt check
* terraform validate

This ensures code quality and prevents broken infrastructure changes.

---

## Deployment Steps

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

---

## Outputs

```bash
terraform output
```

Includes:

* EC2 public IPs
* RDS endpoint
* ALB DNS name

---

## Access Application

```bash
http://<ALB_DNS_NAME>
```

---

## SSH Access

```bash
ssh -i ~/iac-key.pem ec2-user@<WEB1_PUBLIC_IP>
```

---

## Validate RDS Connectivity

```bash
sudo dnf install mariadb105 -y
mysql -h <RDS_ENDPOINT> -u admin -p
```

---

## Security Design

* EC2 allows: 22, 80, 443
* RDS allows: 3306 only from EC2
* RDS is private (not publicly accessible)

---

## Troubleshooting

* Ensure correct AWS region
* Verify key pair exists
* Check security groups for connectivity issues
* Confirm RDS is available before connecting

---

## Destroy Infrastructure

```bash
terraform destroy
```

---

## Notes

* terraform.tfvars is excluded from Git
* No secrets are stored in the repository
* Architecture reflects real-world cloud design principles

---

## Future Improvements

* Auto Scaling Group
* Remote Terraform State (S3 + DynamoDB)
* CloudWatch Monitoring
* Route 53 + HTTPS
* CI/CD Deployment Pipeline
