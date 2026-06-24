output "eks_kms_key_arn" {
  value = module.security.eks_kms_key_arn
}

output "eks_cluster_security_group_id" {
  value = module.security.eks_cluster_security_group_id
}

output "eks_node_security_group_id" {
  value = module.security.eks_node_security_group_id
}
