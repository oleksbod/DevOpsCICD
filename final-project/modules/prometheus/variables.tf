variable "namespace" {
  description = "Namespace для Prometheus"
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "Версія Helm chart для Prometheus"
  type        = string
  default     = "55.0.0"
}

variable "retention" {
  description = "Час зберігання метрик"
  type        = string
  default     = "15d"
}

variable "storage_size" {
  description = "Розмір сховища для Prometheus"
  type        = string
  default     = "20Gi"
}

variable "cpu_request" {
  description = "CPU request для Prometheus"
  type        = string
  default     = "200m"
}

variable "memory_request" {
  description = "Memory request для Prometheus"
  type        = string
  default     = "512Mi"
}

variable "cpu_limit" {
  description = "CPU limit для Prometheus"
  type        = string
  default     = "1000m"
}

variable "memory_limit" {
  description = "Memory limit для Prometheus"
  type        = string
  default     = "2Gi"
}

variable "tags" {
  description = "Теги для ресурсів"
  type        = map(string)
  default     = {}
}
