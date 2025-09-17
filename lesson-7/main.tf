terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
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
    Project = "lesson-7"
  }
}

# Підключаємо модуль VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "lesson-7-vpc"
  tags = {
    Project = "lesson-7"
  }
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-7-django"
  scan_on_push = true
}

# 4) EKS 
module "eks" {
  source = "./modules/eks"

  cluster_name        = "lesson-7-eks"
  cluster_version     = "1.29"
  vpc_id              = module.vpc.vpc_id 
  public_subnet_ids   = module.vpc.public_subnets

  ng_instance_types   = ["t3.small"]  
  ng_desired_size     = 1              
  ng_min_size         = 1              
  ng_max_size         = 1 
}