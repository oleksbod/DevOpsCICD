terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}


# Підключаємо модуль S3 + DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-oleksandr"
  table_name  = "terraform-locks"
  tags = {
    Project = "lesson-db-module"
  }
}

# Підключаємо модуль VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "lesson-8-9-vpc"
  tags = {
    Project = "lesson-db-module"
  }
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-db-module-django"
  scan_on_push = true
}

# 4) EKS 
module "eks" {
  source = "./modules/eks"

  cluster_name        = "lesson-db-module-eks"
  cluster_version     = "1.29"
  vpc_id              = module.vpc.vpc_id 
  public_subnet_ids   = module.vpc.public_subnets

  ng_instance_types   = ["t3.large"]  
  ng_desired_size     = 2              
  ng_min_size         = 1              
  ng_max_size         = 3 
}

# Data sources для підключення до EKS
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

# Helm provider для роботи з EKS
provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

# Kubernetes provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

# RDS модуль
module "rds" {
  source = "./modules/rds"
  
  # Basic configuration
  use_aurora = var.use_aurora
  engine     = var.rds_engine
  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class
  multi_az   = var.rds_multi_az
  
  # Database configuration
  database_name   = var.rds_database_name
  master_username = var.rds_master_username
  master_password = var.rds_master_password
  
  # Storage configuration
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  storage_type         = var.rds_storage_type
  storage_encrypted    = var.rds_storage_encrypted
  
  # Backup configuration
  backup_retention_period = var.rds_backup_retention_period
  backup_window          = var.rds_backup_window
  maintenance_window     = var.rds_maintenance_window
  
  # Network configuration
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  # Security configuration
  allowed_cidr_blocks = var.rds_allowed_cidr_blocks
  allowed_security_groups = var.rds_allowed_security_groups
  
  # Parameter configuration
  max_connections = var.rds_max_connections
  log_statement  = var.rds_log_statement
  work_mem       = var.rds_work_mem
  
  # Aurora configuration
  aurora_cluster_instances = var.aurora_cluster_instances
  aurora_auto_pause        = var.aurora_auto_pause
  aurora_seconds_until_auto_pause = var.aurora_seconds_until_auto_pause
  aurora_max_capacity      = var.aurora_max_capacity
  aurora_min_capacity      = var.aurora_min_capacity
  
  # Protection
  deletion_protection = var.rds_deletion_protection
  skip_final_snapshot = var.rds_skip_final_snapshot
  
  tags = {
    Project = "lesson-db-module"
  }
}

# 5) Jenkins модуль
module "jenkins" {
  source = "./modules/jenkins"
  
  cluster_name        = module.eks.cluster_name
  oidc_provider_arn   = module.eks.oidc_provider_arn
  oidc_provider_url   = module.eks.oidc_provider_url
  ecr_repo_url        = module.ecr.ecr_repo_url
  github_token        = var.github_token
  github_username     = var.github_username

  providers = {
    helm = helm
  }
  
  depends_on = [module.eks]
}

# 6) Argo CD модуль
module "argo_cd" {
  source = "./modules/argo_cd"
  
  name            = "argo-cd"
  namespace       = "argocd"
  chart_version   = "5.46.4"
  ecr_repo_url    = module.ecr.ecr_repo_url
  github_repo_url = "https://github.com/oleksbod/DevOpsCICD.git"

  providers = {
    helm = helm
  }
  
  depends_on = [module.eks]
}