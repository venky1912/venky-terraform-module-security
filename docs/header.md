# venky-terraform-module-security

Generic Terraform module for provisioning security resources for any workload.

## Features

- KMS keys with automatic rotation and configurable policies
- Security groups with flexible ingress/egress rules
- Supports any service (EKS, RDS, EC2, ALB, etc.)
- Least-privilege by default

## Usage

```hcl
module "security" {
  source = "git::https://github.com/venky1912/venky-terraform-module-security.git?ref=v0.2.0"

  name = "platform-dev"

  kms_keys = {
    eks = { description = "EKS cluster encryption" }
    rds = { description = "RDS encryption" }
  }

  security_groups = {
    eks-cluster = {
      vpc_id      = module.vpc.vpc_id
      description = "EKS cluster control plane"
      ingress_rules = {
        https = { from_port = 443, to_port = 443, ip_protocol = "tcp", cidr_ipv4 = "10.0.0.0/16" }
      }
      egress_rules = {
        all = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
      }
    }
    alb = {
      vpc_id      = module.vpc.vpc_id
      description = "Application Load Balancer"
      ingress_rules = {
        http  = { from_port = 80, to_port = 80, ip_protocol = "tcp", cidr_ipv4 = "0.0.0.0/0" }
        https = { from_port = 443, to_port = 443, ip_protocol = "tcp", cidr_ipv4 = "0.0.0.0/0" }
      }
      egress_rules = {
        all = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
      }
    }
  }

  tags = { Environment = "dev", ManagedBy = "terraform" }
}
```
