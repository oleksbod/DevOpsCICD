# Shared resources for RDS module

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Random password if not provided
resource "random_password" "master_password" {
  count   = var.master_password == "" ? 1 : 0
  length  = 16
  special = true
}

# Local values for computed attributes
locals {
  # Use provided password or generate random one
  master_password = var.master_password != "" ? var.master_password : random_password.master_password[0].result
  
  # Engine version mapping for RDS
  engine_versions = {
    postgres = {
      "13" = "13.15"
      "14" = "14.15"
      "15" = "15.14"
    }
    mysql = {
      "8.0" = "8.0.43"
      "5.7" = "5.7.44"
    }
  }

  # Engine version mapping for Aurora
  aurora_engine_versions = {
    postgres = {
      "13" = "13.15"
      "14" = "14.15"
      "15" = "15.13"
    }
    mysql = {
      "8.0" = "8.0.mysql_aurora.3.10.0"
      "5.7" = "5.7.mysql_aurora.2.12.0"
    }
  }
  
  # Default engine version for RDS
  default_engine_version = var.engine == "postgres" ? "15.14" : "8.0.43"
  
  # Default engine version for Aurora
  default_aurora_engine_version = var.engine == "postgres" ? "15.13" : "8.0.mysql_aurora.3.10.0"
  
  # Final engine version for RDS
  engine_version = var.engine_version != "" ? var.engine_version : local.default_engine_version
  
  # Final engine version for Aurora
  aurora_engine_version = var.engine_version != "" ? var.engine_version : local.default_aurora_engine_version
  
  # Parameter group family
  parameter_group_families = {
    postgres = "postgres${split(".", local.engine_version)[0]}"
    mysql    = "mysql${split(".", local.engine_version)[0]}.${split(".", local.engine_version)[1]}"
  }
  
  parameter_group_family = var.parameter_group_family != "" ? var.parameter_group_family : local.parameter_group_families[var.engine]
  
  # Default port
  default_ports = {
    postgres = 5432
    mysql    = 3306
  }
  
  port = var.port != null ? var.port : local.default_ports[var.engine]
  
  # Final snapshot identifier
  final_snapshot_id = var.final_snapshot_identifier != "" ? var.final_snapshot_identifier : "${var.database_name}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  
  # Common tags
  common_tags = merge(var.tags, {
    Module = "rds"
    Engine = var.engine
  })
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.database_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.database_name}-subnet-group"
  })
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "${var.database_name}-rds-"
  vpc_id      = var.vpc_id

  # Ingress rules
  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = local.port
      to_port     = local.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "Database access from ${ingress.value}"
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_security_groups
    content {
      from_port       = local.port
      to_port         = local.port
      protocol        = "tcp"
      security_groups = [ingress.value]
      description     = "Database access from security group ${ingress.value}"
    }
  }

  # Egress rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(local.common_tags, {
    Name = "${var.database_name}-rds-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Parameter Group
resource "aws_db_parameter_group" "main" {
  count  = var.use_aurora ? 0 : 1
  family = local.parameter_group_family
  name   = "${var.database_name}-params"

  dynamic "parameter" {
    for_each = var.engine == "postgres" ? [
      {
        name         = "max_connections"
        value        = tostring(var.max_connections)
        apply_method = "pending-reboot"
      },
      {
        name         = "log_statement"
        value        = var.log_statement
        apply_method = "immediate"
      },
      {
        name         = "work_mem"
        value        = tostring(var.work_mem * 1024)
        apply_method = "pending-reboot"
      }
    ] : [
      {
        name         = "max_connections"
        value        = tostring(var.max_connections)
        apply_method = "pending-reboot"
      }
    ]
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.database_name}-params"
  })
}

# Aurora Cluster Parameter Group
resource "aws_rds_cluster_parameter_group" "main" {
  count  = var.use_aurora ? 1 : 0
  family = local.parameter_group_family
  name   = "${var.database_name}-cluster-params"

  dynamic "parameter" {
    for_each = var.engine == "postgres" ? [
      {
        name         = "max_connections"
        value        = tostring(var.max_connections)
        apply_method = "pending-reboot"
      },
      {
        name         = "log_statement"
        value        = var.log_statement
        apply_method = "immediate"
      },
      {
        name         = "work_mem"
        value        = tostring(var.work_mem * 1024)
        apply_method = "pending-reboot"
      }
    ] : [
      {
        name         = "max_connections"
        value        = tostring(var.max_connections)
        apply_method = "pending-reboot"
      }
    ]
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.database_name}-cluster-params"
  })
}
