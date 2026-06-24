<!-- BEGIN_TF_DOCS -->
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

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for all resources | `string` | n/a | yes |
| <a name="input_kms_keys"></a> [kms\_keys](#input\_kms\_keys) | Map of KMS keys to create.<br/>Example:<br/>{<br/>  eks = {<br/>    description             = "EKS cluster encryption"<br/>    deletion\_window\_in\_days = 30<br/>    enable\_key\_rotation     = true<br/>  }<br/>  rds = {<br/>    description = "RDS encryption"<br/>  }<br/>} | <pre>map(object({<br/>    description                  = optional(string)<br/>    deletion_window_in_days      = optional(number, 30)<br/>    enable_key_rotation          = optional(bool, true)<br/>    additional_policy_statements = optional(list(any), [])<br/>    tags                         = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Map of security groups to create with their rules.<br/>Example:<br/>{<br/>  eks-cluster = {<br/>    vpc\_id      = "vpc-123"<br/>    description = "EKS cluster SG"<br/>    ingress\_rules = {<br/>      https = { from\_port = 443, to\_port = 443, ip\_protocol = "tcp", cidr\_ipv4 = "10.0.0.0/16" }<br/>    }<br/>    egress\_rules = {<br/>      all = { ip\_protocol = "-1", cidr\_ipv4 = "0.0.0.0/0" }<br/>    }<br/>  }<br/>} | <pre>map(object({<br/>    vpc_id      = string<br/>    description = optional(string)<br/>    tags        = optional(map(string), {})<br/>    ingress_rules = optional(map(object({<br/>      description                  = optional(string)<br/>      from_port                    = number<br/>      to_port                      = number<br/>      ip_protocol                  = string<br/>      cidr_ipv4                    = optional(string)<br/>      referenced_security_group_id = optional(string)<br/>    })), {})<br/>    egress_rules = optional(map(object({<br/>      description                  = optional(string)<br/>      from_port                    = optional(number)<br/>      to_port                      = optional(number)<br/>      ip_protocol                  = string<br/>      cidr_ipv4                    = optional(string)<br/>      referenced_security_group_id = optional(string)<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_kms_alias_arns"></a> [kms\_alias\_arns](#output\_kms\_alias\_arns) | Map of KMS alias ARNs |
| <a name="output_kms_key_arns"></a> [kms\_key\_arns](#output\_kms\_key\_arns) | Map of KMS key ARNs |
| <a name="output_kms_key_ids"></a> [kms\_key\_ids](#output\_kms\_key\_ids) | Map of KMS key IDs |
| <a name="output_security_group_arns"></a> [security\_group\_arns](#output\_security\_group\_arns) | Map of security group ARNs |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | Map of security group IDs |
<!-- END_TF_DOCS -->