# Outputs for lesson-db-module

# S3 Backend outputs
output "s3_bucket_name" {
  value       = module.s3_backend.s3_bucket_name
  description = "Назва S3-бакета"
}

output "dynamodb_table_name" {
  value       = module.s3_backend.dynamodb_table_name
  description = "Таблиця DynamoDB"
}

# VPC outputs
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

# RDS outputs
output "rds_database_name" {
  description = "Name of the database"
  value       = module.rds.database_name
}

output "rds_master_username" {
  description = "Master username for the database"
  value       = module.rds.master_username
}

output "rds_port" {
  description = "Database port"
  value       = module.rds.port
}

output "rds_engine" {
  description = "Database engine"
  value       = module.rds.engine
}

output "rds_engine_version" {
  description = "Database engine version"
  value       = module.rds.engine_version
}

output "rds_use_aurora" {
  description = "Whether Aurora cluster is used"
  value       = module.rds.use_aurora
}

# RDS Instance outputs (when use_aurora = false)
output "rds_instance_id" {
  description = "RDS instance ID"
  value       = module.rds.rds_instance_id
}

output "rds_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.rds_instance_endpoint
}

output "rds_instance_address" {
  description = "RDS instance address"
  value       = module.rds.rds_instance_address
}

# Aurora Cluster outputs (when use_aurora = true)
output "aurora_cluster_id" {
  description = "Aurora cluster ID"
  value       = module.rds.aurora_cluster_id
}

output "aurora_cluster_endpoint" {
  description = "Aurora cluster endpoint"
  value       = module.rds.aurora_cluster_endpoint
}

output "aurora_cluster_reader_endpoint" {
  description = "Aurora cluster reader endpoint"
  value       = module.rds.aurora_cluster_reader_endpoint
}

# Security outputs
output "rds_security_group_id" {
  description = "Security group ID for the database"
  value       = module.rds.security_group_id
}

# Connection information
output "rds_connection_string" {
  description = "Database connection string (sensitive)"
  value       = module.rds.connection_string
  sensitive   = true
}

# ECR outputs
output "ecr_repo_url" {
  value       = module.ecr.ecr_repo_url
  description = "URL ECR репозиторію"
}

# EKS outputs
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