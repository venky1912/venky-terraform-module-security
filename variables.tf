################################################################################
# General
################################################################################

variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID to create security groups in"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block for default ingress rules"
  type        = string
}

################################################################################
# KMS
################################################################################

variable "create_eks_kms_key" {
  description = "Whether to create a KMS key for EKS cluster encryption"
  type        = bool
  default     = true
}

variable "kms_key_deletion_window" {
  description = "KMS key deletion window in days"
  type        = number
  default     = 30
}

variable "kms_key_enable_rotation" {
  description = "Enable automatic key rotation for KMS keys"
  type        = bool
  default     = true
}

variable "kms_key_additional_admin_arns" {
  description = "Additional IAM ARNs that can administer the KMS key"
  type        = list(string)
  default     = []
}

################################################################################
# Security Groups
################################################################################

variable "create_eks_cluster_sg" {
  description = "Whether to create a security group for the EKS cluster"
  type        = bool
  default     = true
}

variable "create_eks_node_sg" {
  description = "Whether to create a security group for EKS nodes"
  type        = bool
  default     = true
}

variable "eks_cluster_sg_additional_rules" {
  description = "Additional security group rules for the EKS cluster"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "eks_node_sg_additional_rules" {
  description = "Additional security group rules for EKS nodes"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}
