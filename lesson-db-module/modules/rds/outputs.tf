# RDS Module Outputs

# Database connection information
output "database_name" {
  description = "Name of the database"
  value       = var.database_name
}

output "master_username" {
  description = "Master username for the database"
  value       = var.master_username
}

output "master_password" {
  description = "Master password for the database"
  value       = local.master_password
  sensitive   = true
}

output "port" {
  description = "Database port"
  value       = local.port
}

# RDS Instance outputs (when use_aurora = false)
output "rds_instance_id" {
  description = "RDS instance ID"
  value       = var.use_aurora ? null : aws_db_instance.main[0].id
}

output "rds_instance_arn" {
  description = "RDS instance ARN"
  value       = var.use_aurora ? null : aws_db_instance.main[0].arn
}

output "rds_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = var.use_aurora ? null : aws_db_instance.main[0].endpoint
}

output "rds_instance_address" {
  description = "RDS instance address"
  value       = var.use_aurora ? null : aws_db_instance.main[0].address
}

output "rds_instance_hosted_zone_id" {
  description = "RDS instance hosted zone ID"
  value       = var.use_aurora ? null : aws_db_instance.main[0].hosted_zone_id
}

# Aurora Cluster outputs (when use_aurora = true)
output "aurora_cluster_id" {
  description = "Aurora cluster ID"
  value       = var.use_aurora ? aws_rds_cluster.main[0].id : null
}

output "aurora_cluster_arn" {
  description = "Aurora cluster ARN"
  value       = var.use_aurora ? aws_rds_cluster.main[0].arn : null
}

output "aurora_cluster_endpoint" {
  description = "Aurora cluster endpoint"
  value       = var.use_aurora ? aws_rds_cluster.main[0].endpoint : null
}

output "aurora_cluster_reader_endpoint" {
  description = "Aurora cluster reader endpoint"
  value       = var.use_aurora ? aws_rds_cluster.main[0].reader_endpoint : null
}

output "aurora_cluster_hosted_zone_id" {
  description = "Aurora cluster hosted zone ID"
  value       = var.use_aurora ? aws_rds_cluster.main[0].hosted_zone_id : null
}

output "aurora_cluster_instances" {
  description = "Aurora cluster instances"
  value       = var.use_aurora ? aws_rds_cluster_instance.main[*].id : []
}

# Common outputs
output "engine" {
  description = "Database engine"
  value       = var.engine
}

output "engine_version" {
  description = "Database engine version"
  value       = local.engine_version
}

output "use_aurora" {
  description = "Whether Aurora cluster is used"
  value       = var.use_aurora
}

# Security Group
output "security_group_id" {
  description = "Security group ID for the database"
  value       = aws_security_group.rds.id
}

# Subnet Group
output "subnet_group_id" {
  description = "DB subnet group ID"
  value       = aws_db_subnet_group.main.id
}

# Parameter Groups
output "parameter_group_id" {
  description = "Parameter group ID (for RDS)"
  value       = var.use_aurora ? null : aws_db_parameter_group.main[0].id
}

output "cluster_parameter_group_id" {
  description = "Cluster parameter group ID (for Aurora)"
  value       = var.use_aurora ? aws_rds_cluster_parameter_group.main[0].id : null
}

# Connection string
output "connection_string" {
  description = "Database connection string"
  value = var.use_aurora ? (
    var.engine == "postgres" ? (
      "postgresql://${var.master_username}:${local.master_password}@${aws_rds_cluster.main[0].endpoint}:${local.port}/${var.database_name}"
    ) : (
      "mysql://${var.master_username}:${local.master_password}@${aws_rds_cluster.main[0].endpoint}:${local.port}/${var.database_name}"
    )
  ) : (
    var.engine == "postgres" ? (
      "postgresql://${var.master_username}:${local.master_password}@${aws_db_instance.main[0].endpoint}:${local.port}/${var.database_name}"
    ) : (
      "mysql://${var.master_username}:${local.master_password}@${aws_db_instance.main[0].endpoint}:${local.port}/${var.database_name}"
    )
  )
  sensitive = true
}
