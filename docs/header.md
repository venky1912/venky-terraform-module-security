# venky-terraform-module-security

Terraform module for provisioning security resources for EKS platforms.

## Features

- KMS key for EKS secrets encryption with key rotation
- EKS cluster security group with least-privilege rules
- EKS node security group with node-to-node and cluster communication
- Additional custom security group rules support
- Secure-by-default configuration

## Usage

```hcl
module "security" {
  source = "git::https://github.com/venky1912/venky-terraform-module-security.git?ref=v0.1.0"

  name           = "platform-dev"
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block

  create_eks_kms_key   = true
  create_eks_cluster_sg = true
  create_eks_node_sg    = true

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```
