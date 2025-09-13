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
