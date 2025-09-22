# Variables for lesson-db-module

# RDS Configuration
variable "use_aurora" {
  description = "Whether to create Aurora cluster or regular RDS instance"
  type        = bool
  default     = false
}

variable "rds_engine" {
  description = "Database engine (postgres, mysql)"
  type        = string
  default     = "postgres"
  validation {
    condition     = contains(["postgres", "mysql"], var.rds_engine)
    error_message = "Engine must be either 'postgres' or 'mysql'."
  }
}

variable "rds_engine_version" {
  description = "Database engine version"
  type        = string
  default     = ""
}

variable "rds_instance_class" {
  description = "Instance class for RDS or Aurora"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS instance (GB)"
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "Maximum allocated storage for RDS instance (GB)"
  type        = number
  default     = 100
}

variable "rds_storage_type" {
  description = "Storage type for RDS instance"
  type        = string
  default     = "gp2"
}

variable "rds_storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "rds_database_name" {
  description = "Name of the database to create"
  type        = string
  default     = "mydb"
}

variable "rds_master_username" {
  description = "Master username for the database"
  type        = string
  default     = "dbadmin"
}

variable "rds_master_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
  default     = ""
}

variable "rds_backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "rds_backup_window" {
  description = "Backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "rds_maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "rds_allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the database"
  type        = list(string)
  default     = []
}

variable "rds_allowed_security_groups" {
  description = "List of security group IDs allowed to access the database"
  type        = list(string)
  default     = []
}

variable "rds_max_connections" {
  description = "Maximum number of connections"
  type        = number
  default     = 100
}

variable "rds_log_statement" {
  description = "Log statement setting for PostgreSQL"
  type        = string
  default     = "none"
}

variable "rds_work_mem" {
  description = "Work memory setting for PostgreSQL (MB)"
  type        = number
  default     = 4
}

variable "rds_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot when deleting"
  type        = bool
  default     = false
}

# Aurora Configuration
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

# GitHub Configuration
variable "github_token" {
  description = "GitHub Personal Access Token для Jenkins"
  type        = string
  default     = ""
}

variable "github_username" {
  description = "GitHub username для Jenkins"
  type        = string
  default     = ""
}
