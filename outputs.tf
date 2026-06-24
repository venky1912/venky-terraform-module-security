################################################################################
# KMS
################################################################################

output "eks_kms_key_arn" {
  description = "ARN of the KMS key for EKS cluster encryption"
  value       = try(aws_kms_key.eks[0].arn, null)
}

output "eks_kms_key_id" {
  description = "ID of the KMS key for EKS cluster encryption"
  value       = try(aws_kms_key.eks[0].key_id, null)
}

output "eks_kms_alias_arn" {
  description = "ARN of the KMS alias"
  value       = try(aws_kms_alias.eks[0].arn, null)
}

################################################################################
# Security Groups
################################################################################

output "eks_cluster_security_group_id" {
  description = "ID of the EKS cluster security group"
  value       = try(aws_security_group.eks_cluster[0].id, null)
}

output "eks_node_security_group_id" {
  description = "ID of the EKS node security group"
  value       = try(aws_security_group.eks_node[0].id, null)
}
