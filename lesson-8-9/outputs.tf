output "s3_bucket_name" {
  value       = module.s3_backend.s3_bucket_name
  description = "Назва S3-бакета"
}

output "dynamodb_table_name" {
  value       = module.s3_backend.dynamodb_table_name
  description = "Таблиця DynamoDB"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "ID VPC"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "Список публічних підмереж"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "Список приватних підмереж"
}

output "ecr_repo_url" {
  value       = module.ecr.ecr_repo_url
  description = "URL ECR репозиторію"
}

output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "Назва EKS кластера"
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "API endpoint EKS кластера"
}

output "eks_kubeconfig_command" {
  value       = "aws eks update-kubeconfig --region eu-central-1 --name ${module.eks.cluster_name}"
  description = "Команда для налаштування kubectl"
}

# Jenkins outputs
output "jenkins_release" {
  value = module.jenkins.jenkins_release_name
}

output "jenkins_namespace" {
  value = module.jenkins.jenkins_namespace
}

output "jenkins_admin_password" {
  value = module.jenkins.admin_password_command
}

# Argo CD outputs
output "argo_cd_server_service" {
  value = module.argo_cd.argo_cd_server_service
}

output "argo_cd_admin_password" {
  value = module.argo_cd.admin_password
}

output "argo_cd_url" {
  value = module.argo_cd.argo_cd_url
}