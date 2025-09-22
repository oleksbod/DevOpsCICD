variable "cluster_name" {
  description = "Назва Kubernetes кластера"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN OIDC провайдера для IRSA"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL OIDC провайдера"
  type        = string
}

variable "ecr_repo_url" {
  description = "URL ECR репозиторію"
  type        = string
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  default     = ""
}

variable "github_username" {
  description = "GitHub username"
  type        = string
  default     = ""
}
