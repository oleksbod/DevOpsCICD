# RDS Module Variables

variable "use_aurora" {
  description = "Whether to create Aurora cluster or regular RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Database engine (postgres, mysql)"
  type        = string
  default     = "postgres"
  validation {
    condition     = contains(["postgres", "mysql"], var.engine)
    error_message = "Engine must be either 'postgres' or 'mysql'."
  }
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = ""
}

variable "instance_class" {
  description = "Instance class for RDS or Aurora"
  type        = string
  default     = "db.t3.micro"
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "Allocated storage for RDS instance (GB)"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage for RDS instance (GB)"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "Storage type for RDS instance"
  type        = string
  default     = "gp2"
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
  default     = "mydb"
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
  default     = "dbadmin"
}

variable "master_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "Final snapshot identifier"
  type        = string
  default     = ""
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID where the database will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the database subnet group"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the database"
  type        = list(string)
  default     = []
}

variable "allowed_security_groups" {
  description = "List of security group IDs allowed to access the database"
  type        = list(string)
  default     = []
}

variable "port" {
  description = "Database port"
  type        = number
  default     = null
}

variable "parameter_group_family" {
  description = "Parameter group family"
  type        = string
  default     = ""
}

variable "max_connections" {
  description = "Maximum number of connections"
  type        = number
  default     = 100
}

variable "log_statement" {
  description = "Log statement setting for PostgreSQL"
  type        = string
  default     = "none"
}

variable "work_mem" {
  description = "Work memory setting for PostgreSQL (MB)"
  type        = number
  default     = 4
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}

# Aurora specific variables
variable "aurora_cluster_instances" {
  description = "Number of Aurora cluster instances"
  type        = number
  default     = 1
}

variable "aurora_auto_pause" {
  description = "Enable auto pause for Aurora Serverless"
  type        = bool
  default     = false
}

variable "aurora_seconds_until_auto_pause" {
  description = "Seconds until auto pause for Aurora Serverless"
  type        = number
  default     = 300
}

variable "aurora_max_capacity" {
  description = "Maximum capacity for Aurora Serverless"
  type        = number
  default     = 16
}

variable "aurora_min_capacity" {
  description = "Minimum capacity for Aurora Serverless"
  type        = number
  default     = 2
}
