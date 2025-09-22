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

# Змінні для CI/CD
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

# Підключаємо модуль S3 + DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-oleksandr"
  table_name  = "terraform-locks"
  tags = {
    Project = "lesson-8-9"
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
    Project = "lesson-8-9"
  }
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-8-9-django"
  scan_on_push = true
}

# 4) EKS 
module "eks" {
  source = "./modules/eks"

  cluster_name        = "lesson-8-9-eks"
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