################################################################################
# KMS
################################################################################

output "kms_key_arns" {
  description = "Map of KMS key ARNs"
  value       = { for k, v in aws_kms_key.this : k => v.arn }
}

output "kms_key_ids" {
  description = "Map of KMS key IDs"
  value       = { for k, v in aws_kms_key.this : k => v.key_id }
}

output "kms_alias_arns" {
  description = "Map of KMS alias ARNs"
  value       = { for k, v in aws_kms_alias.this : k => v.arn }
}

################################################################################
# Security Groups
################################################################################

output "security_group_ids" {
  description = "Map of security group IDs"
  value       = { for k, v in aws_security_group.this : k => v.id }
}

output "security_group_arns" {
  description = "Map of security group ARNs"
  value       = { for k, v in aws_security_group.this : k => v.arn }
}
