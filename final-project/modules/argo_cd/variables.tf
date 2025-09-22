variable "name" {
  description = "Назва Helm-релізу"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "K8s namespace для Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Версія Argo CD чарта"
  type        = string
  default     = "5.46.4"
}

variable "ecr_repo_url" {
  description = "URL ECR репозиторію"
  type        = string
}

variable "github_repo_url" {
  description = "URL GitHub репозиторію з Helm charts"
  type        = string
  default     = "https://github.com/AndriyDmitriv/infra.git"
}
