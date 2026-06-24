################################################################################
# KMS Keys (Generic)
################################################################################

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "this" {
  for_each = var.kms_keys

  description             = try(each.value.description, "KMS key for ${each.key} - ${var.name}")
  deletion_window_in_days = try(each.value.deletion_window_in_days, 30)
  enable_key_rotation     = try(each.value.enable_key_rotation, true)

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Sid    = "EnableRootAccountAccess"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          }
          Action   = "kms:*"
          Resource = "*"
        }
      ],
      try(each.value.additional_policy_statements, [])
    )
  })

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name = "${var.name}-${each.key}"
  })
}

resource "aws_kms_alias" "this" {
  for_each = var.kms_keys

  name          = "alias/${var.name}-${each.key}"
  target_key_id = aws_kms_key.this[each.key].key_id
}

################################################################################
# Security Groups (Generic)
################################################################################

resource "aws_security_group" "this" {
  for_each = var.security_groups

  name_prefix = "${var.name}-${each.key}-"
  description = try(each.value.description, "Security group for ${each.key}")
  vpc_id      = each.value.vpc_id

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name = "${var.name}-${each.key}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for item in local.ingress_rules : "${item.sg_key}-${item.rule_key}" => item }

  security_group_id            = aws_security_group.this[each.value.sg_key].id
  description                  = each.value.description
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)

  tags = merge(var.tags, {
    Name = "${var.name}-${each.value.sg_key}-${each.value.rule_key}"
  })
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = { for item in local.egress_rules : "${item.sg_key}-${item.rule_key}" => item }

  security_group_id            = aws_security_group.this[each.value.sg_key].id
  description                  = each.value.description
  from_port                    = try(each.value.from_port, null)
  to_port                      = try(each.value.to_port, null)
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)

  tags = merge(var.tags, {
    Name = "${var.name}-${each.value.sg_key}-${each.value.rule_key}"
  })
}

locals {
  ingress_rules = flatten([
    for sg_key, sg_config in var.security_groups : [
      for rule_key, rule in try(sg_config.ingress_rules, {}) : {
        sg_key                       = sg_key
        rule_key                     = rule_key
        description                  = try(rule.description, "Ingress ${rule_key}")
        from_port                    = rule.from_port
        to_port                      = rule.to_port
        ip_protocol                  = rule.ip_protocol
        cidr_ipv4                    = try(rule.cidr_ipv4, null)
        referenced_security_group_id = try(rule.referenced_security_group_id, null)
      }
    ]
  ])

  egress_rules = flatten([
    for sg_key, sg_config in var.security_groups : [
      for rule_key, rule in try(sg_config.egress_rules, {}) : {
        sg_key                       = sg_key
        rule_key                     = rule_key
        description                  = try(rule.description, "Egress ${rule_key}")
        from_port                    = try(rule.from_port, null)
        to_port                      = try(rule.to_port, null)
        ip_protocol                  = rule.ip_protocol
        cidr_ipv4                    = try(rule.cidr_ipv4, null)
        referenced_security_group_id = try(rule.referenced_security_group_id, null)
      }
    ]
  ])
}
