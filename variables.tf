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

################################################################################
# KMS Keys
################################################################################

variable "kms_keys" {
  description = <<-EOT
    Map of KMS keys to create.
    Example:
    {
      eks = {
        description             = "EKS cluster encryption"
        deletion_window_in_days = 30
        enable_key_rotation     = true
      }
      rds = {
        description = "RDS encryption"
      }
    }
  EOT
  type = map(object({
    description                  = optional(string)
    deletion_window_in_days      = optional(number, 30)
    enable_key_rotation          = optional(bool, true)
    additional_policy_statements = optional(list(any), [])
    tags                         = optional(map(string), {})
  }))
  default = {}
}

################################################################################
# Security Groups
################################################################################

variable "security_groups" {
  description = <<-EOT
    Map of security groups to create with their rules.
    Example:
    {
      eks-cluster = {
        vpc_id      = "vpc-123"
        description = "EKS cluster SG"
        ingress_rules = {
          https = { from_port = 443, to_port = 443, ip_protocol = "tcp", cidr_ipv4 = "10.0.0.0/16" }
        }
        egress_rules = {
          all = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
        }
      }
    }
  EOT
  type = map(object({
    vpc_id      = string
    description = optional(string)
    tags        = optional(map(string), {})
    ingress_rules = optional(map(object({
      description                  = optional(string)
      from_port                    = number
      to_port                      = number
      ip_protocol                  = string
      cidr_ipv4                    = optional(string)
      referenced_security_group_id = optional(string)
    })), {})
    egress_rules = optional(map(object({
      description                  = optional(string)
      from_port                    = optional(number)
      to_port                      = optional(number)
      ip_protocol                  = string
      cidr_ipv4                    = optional(string)
      referenced_security_group_id = optional(string)
    })), {})
  }))
  default = {}
}
