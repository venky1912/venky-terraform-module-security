################################################################################
# KMS Key for EKS Cluster Encryption
################################################################################

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "eks" {
  count = var.create_eks_kms_key ? 1 : 0

  description             = "KMS key for EKS cluster encryption - ${var.name}"
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = var.kms_key_enable_rotation

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableRootAccountAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowKeyAdministration"
        Effect = "Allow"
        Principal = {
          AWS = concat(
            ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"],
            var.kms_key_additional_admin_arns
          )
        }
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion",
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowEKSServiceUsage"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant",
        ]
        Resource = "*"
      },
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.name}-eks-kms"
  })
}

resource "aws_kms_alias" "eks" {
  count = var.create_eks_kms_key ? 1 : 0

  name          = "alias/${var.name}-eks"
  target_key_id = aws_kms_key.eks[0].key_id
}

################################################################################
# EKS Cluster Security Group
################################################################################

resource "aws_security_group" "eks_cluster" {
  count = var.create_eks_cluster_sg ? 1 : 0

  name_prefix = "${var.name}-eks-cluster-"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-eks-cluster-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_egress_rule" "eks_cluster_all" {
  count = var.create_eks_cluster_sg ? 1 : 0

  security_group_id = aws_security_group.eks_cluster[0].id
  description       = "Allow all egress"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = merge(var.tags, {
    Name = "${var.name}-eks-cluster-egress-all"
  })
}

resource "aws_vpc_security_group_ingress_rule" "eks_cluster_nodes" {
  count = var.create_eks_cluster_sg && var.create_eks_node_sg ? 1 : 0

  security_group_id            = aws_security_group.eks_cluster[0].id
  description                  = "Allow nodes to communicate with cluster API"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.eks_node[0].id

  tags = merge(var.tags, {
    Name = "${var.name}-eks-cluster-ingress-nodes"
  })
}

resource "aws_vpc_security_group_ingress_rule" "eks_cluster_additional" {
  count = var.create_eks_cluster_sg ? length(var.eks_cluster_sg_additional_rules) : 0

  security_group_id = aws_security_group.eks_cluster[0].id
  description       = var.eks_cluster_sg_additional_rules[count.index].description
  from_port         = var.eks_cluster_sg_additional_rules[count.index].from_port
  to_port           = var.eks_cluster_sg_additional_rules[count.index].to_port
  ip_protocol       = var.eks_cluster_sg_additional_rules[count.index].protocol
  cidr_ipv4         = var.eks_cluster_sg_additional_rules[count.index].cidr_blocks[0]

  tags = merge(var.tags, {
    Name = "${var.name}-eks-cluster-ingress-${count.index}"
  })
}

################################################################################
# EKS Node Security Group
################################################################################

resource "aws_security_group" "eks_node" {
  count = var.create_eks_node_sg ? 1 : 0

  name_prefix = "${var.name}-eks-node-"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-eks-node-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_egress_rule" "eks_node_all" {
  count = var.create_eks_node_sg ? 1 : 0

  security_group_id = aws_security_group.eks_node[0].id
  description       = "Allow all egress"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = merge(var.tags, {
    Name = "${var.name}-eks-node-egress-all"
  })
}

resource "aws_vpc_security_group_ingress_rule" "eks_node_self" {
  count = var.create_eks_node_sg ? 1 : 0

  security_group_id            = aws_security_group.eks_node[0].id
  description                  = "Allow nodes to communicate with each other"
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.eks_node[0].id

  tags = merge(var.tags, {
    Name = "${var.name}-eks-node-ingress-self"
  })
}

resource "aws_vpc_security_group_ingress_rule" "eks_node_cluster" {
  count = var.create_eks_node_sg && var.create_eks_cluster_sg ? 1 : 0

  security_group_id            = aws_security_group.eks_node[0].id
  description                  = "Allow cluster to communicate with nodes"
  from_port                    = 1025
  to_port                      = 65535
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.eks_cluster[0].id

  tags = merge(var.tags, {
    Name = "${var.name}-eks-node-ingress-cluster"
  })
}

resource "aws_vpc_security_group_ingress_rule" "eks_node_cluster_https" {
  count = var.create_eks_node_sg && var.create_eks_cluster_sg ? 1 : 0

  security_group_id            = aws_security_group.eks_node[0].id
  description                  = "Allow cluster to communicate with nodes (HTTPS)"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.eks_cluster[0].id

  tags = merge(var.tags, {
    Name = "${var.name}-eks-node-ingress-cluster-https"
  })
}

resource "aws_vpc_security_group_ingress_rule" "eks_node_additional" {
  count = var.create_eks_node_sg ? length(var.eks_node_sg_additional_rules) : 0

  security_group_id = aws_security_group.eks_node[0].id
  description       = var.eks_node_sg_additional_rules[count.index].description
  from_port         = var.eks_node_sg_additional_rules[count.index].from_port
  to_port           = var.eks_node_sg_additional_rules[count.index].to_port
  ip_protocol       = var.eks_node_sg_additional_rules[count.index].protocol
  cidr_ipv4         = var.eks_node_sg_additional_rules[count.index].cidr_blocks[0]

  tags = merge(var.tags, {
    Name = "${var.name}-eks-node-ingress-${count.index}"
  })
}
