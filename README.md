# AWS Multi-Tier Infrastructure with Terraform

## Overview

This project provisions a production-style multi-tier AWS environment using Terraform.

The infrastructure is designed with separation between the public application tier and the private database tier. Networking, compute, database provisioning, and access controls are all managed as code using Terraform.

This setup reflects core Infrastructure as Code practices used in real cloud and DevOps environments, including modular file organization, variable-driven configuration, private database placement, and controlled security group access.

---

## Architecture

'''text
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
