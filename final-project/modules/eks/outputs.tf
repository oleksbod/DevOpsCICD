output "cluster_name"        { value = module.eks.cluster_name }
output "cluster_endpoint"    { value = module.eks.cluster_endpoint }
output "eks_node_group_arn" {
  value = module.eks.eks_managed_node_groups["default"].node_group_arn
}

# OIDC outputs для IRSA
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  value = module.eks.cluster_oidc_issuer_url
}