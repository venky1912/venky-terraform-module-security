<!-- BEGIN_TF_DOCS -->
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
| [aws_kms_alias.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.eks_node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.eks_cluster_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.eks_node_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.eks_cluster_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.eks_cluster_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.eks_node_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.eks_node_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.eks_node_cluster_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.eks_node_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for all resources | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR block for default ingress rules | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to create security groups in | `string` | n/a | yes |
| <a name="input_create_eks_cluster_sg"></a> [create\_eks\_cluster\_sg](#input\_create\_eks\_cluster\_sg) | Whether to create a security group for the EKS cluster | `bool` | `true` | no |
| <a name="input_create_eks_kms_key"></a> [create\_eks\_kms\_key](#input\_create\_eks\_kms\_key) | Whether to create a KMS key for EKS cluster encryption | `bool` | `true` | no |
| <a name="input_create_eks_node_sg"></a> [create\_eks\_node\_sg](#input\_create\_eks\_node\_sg) | Whether to create a security group for EKS nodes | `bool` | `true` | no |
| <a name="input_eks_cluster_sg_additional_rules"></a> [eks\_cluster\_sg\_additional\_rules](#input\_eks\_cluster\_sg\_additional\_rules) | Additional security group rules for the EKS cluster | <pre>list(object({<br/>    description = string<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_eks_node_sg_additional_rules"></a> [eks\_node\_sg\_additional\_rules](#input\_eks\_node\_sg\_additional\_rules) | Additional security group rules for EKS nodes | <pre>list(object({<br/>    description = string<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_kms_key_additional_admin_arns"></a> [kms\_key\_additional\_admin\_arns](#input\_kms\_key\_additional\_admin\_arns) | Additional IAM ARNs that can administer the KMS key | `list(string)` | `[]` | no |
| <a name="input_kms_key_deletion_window"></a> [kms\_key\_deletion\_window](#input\_kms\_key\_deletion\_window) | KMS key deletion window in days | `number` | `30` | no |
| <a name="input_kms_key_enable_rotation"></a> [kms\_key\_enable\_rotation](#input\_kms\_key\_enable\_rotation) | Enable automatic key rotation for KMS keys | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_eks_cluster_security_group_id"></a> [eks\_cluster\_security\_group\_id](#output\_eks\_cluster\_security\_group\_id) | ID of the EKS cluster security group |
| <a name="output_eks_kms_alias_arn"></a> [eks\_kms\_alias\_arn](#output\_eks\_kms\_alias\_arn) | ARN of the KMS alias |
| <a name="output_eks_kms_key_arn"></a> [eks\_kms\_key\_arn](#output\_eks\_kms\_key\_arn) | ARN of the KMS key for EKS cluster encryption |
| <a name="output_eks_kms_key_id"></a> [eks\_kms\_key\_id](#output\_eks\_kms\_key\_id) | ID of the KMS key for EKS cluster encryption |
| <a name="output_eks_node_security_group_id"></a> [eks\_node\_security\_group\_id](#output\_eks\_node\_security\_group\_id) | ID of the EKS node security group |
<!-- END_TF_DOCS -->