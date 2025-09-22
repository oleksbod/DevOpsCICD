# Regular RDS Instance

resource "aws_db_instance" "main" {
  count = var.use_aurora ? 0 : 1

  # Basic configuration
  identifier = var.database_name
  engine     = var.engine
  engine_version = local.engine_version
  instance_class = var.instance_class
  port       = local.port

  # Database configuration
  db_name  = var.database_name
  username = var.master_username
  password = local.master_password

  # Storage configuration
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type         = var.storage_type
  storage_encrypted    = var.storage_encrypted
  kms_key_id          = aws_kms_key.rds.arn

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  # High availability
  multi_az = var.multi_az

  # Backup configuration
  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window

  # Snapshot configuration
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : local.final_snapshot_id

  # Protection
  deletion_protection = var.deletion_protection

  # Parameter group
  parameter_group_name = aws_db_parameter_group.main[0].name

  # Monitoring
  monitoring_interval = 0
  monitoring_role_arn = null

  # Performance Insights
  performance_insights_enabled = false

  tags = merge(local.common_tags, {
    Name = var.database_name
    Type = "RDS"
  })

  depends_on = [aws_db_parameter_group.main]
}

# KMS ключ для RDS
resource "aws_kms_key" "rds" {
  description             = "RDS encryption key for ${var.database_name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(local.common_tags, {
    Name = "${var.database_name}-encryption-key"
    Type = "RDS-KMS"
  })
}

resource "aws_kms_alias" "rds" {
  name          = "alias/rds/${var.database_name}"
  target_key_id = aws_kms_key.rds.key_id
}
