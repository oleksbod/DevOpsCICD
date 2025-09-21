module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id = var.vpc_id
  subnet_ids = var.public_subnet_ids  

  enable_cluster_creator_admin_permissions = true

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  # Увімкнути IRSA
  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      instance_types = var.ng_instance_types
      desired_size   = var.ng_desired_size
      min_size       = var.ng_min_size
      max_size       = var.ng_max_size
      subnets        = var.public_subnet_ids
    }
  }

  tags = { Project = "lesson-8-9" }
}

# OIDC Provider створюється автоматично EKS модулем