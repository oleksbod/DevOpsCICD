# Aurora Cluster

resource "aws_rds_cluster" "main" {
  count = var.use_aurora ? 1 : 0

  # Basic configuration
  cluster_identifier = var.database_name
  engine            = var.engine
  engine_mode       = var.aurora_auto_pause ? "serverless" : "provisioned"
  engine_version    = local.aurora_engine_version
  port              = local.port

  # Database configuration
  database_name   = var.database_name
  master_username = var.master_username
  master_password = local.master_password

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Backup configuration
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.backup_window
  preferred_maintenance_window = var.maintenance_window

  # Snapshot configuration
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : local.final_snapshot_id

  # Protection
  deletion_protection = var.deletion_protection

  # Parameter group
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main[0].name

  # Serverless configuration
  dynamic "scaling_configuration" {
    for_each = var.aurora_auto_pause ? [1] : []
    content {
      auto_pause               = true
      max_capacity             = var.aurora_max_capacity
      min_capacity             = var.aurora_min_capacity
      seconds_until_auto_pause = var.aurora_seconds_until_auto_pause
      timeout_action           = "ForceApplyCapacityChange"
    }
  }

  # Storage encryption
  storage_encrypted = var.storage_encrypted

  tags = merge(local.common_tags, {
    Name = "${var.database_name}-cluster"
    Type = "Aurora"
  })

  depends_on = [aws_rds_cluster_parameter_group.main]
}

# Aurora Cluster Instances
resource "aws_rds_cluster_instance" "main" {
  count = var.use_aurora ? var.aurora_cluster_instances : 0

  # Basic configuration
  identifier         = "${var.database_name}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.main[0].id
  instance_class     = var.aurora_auto_pause ? "db.serverless" : var.instance_class
  engine             = var.engine
  engine_version     = local.aurora_engine_version

  # Monitoring
  monitoring_interval = 0
  monitoring_role_arn = null

  # Performance Insights
  performance_insights_enabled = false

  tags = merge(local.common_tags, {
    Name = "${var.database_name}-${count.index + 1}"
    Type = "Aurora-Instance"
  })
}
