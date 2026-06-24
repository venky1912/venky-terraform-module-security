module "security" {
  source = "../../"

  name           = "platform-dev"
  vpc_id         = "vpc-12345678"
  vpc_cidr_block = "10.0.0.0/16"

  create_eks_kms_key    = true
  create_eks_cluster_sg = true
  create_eks_node_sg    = true

  kms_key_deletion_window = 7
  kms_key_enable_rotation = true

  tags = {
    Environment = "dev"
    Project     = "eks-platform"
    ManagedBy   = "terraform"
  }
}
