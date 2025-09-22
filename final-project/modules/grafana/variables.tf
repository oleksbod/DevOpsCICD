variable "namespace" {
  description = "Namespace для Grafana"
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "Версія Helm chart для Grafana"
  type        = string
  default     = "7.0.19"
}

variable "admin_user" {
  description = "Адміністратор користувач Grafana"
  type        = string
  default     = "admin"
}

variable "admin_password" {
  description = "Пароль адміністратора Grafana"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "domain" {
  description = "Домен для Grafana"
  type        = string
  default     = "localhost"
}

variable "anonymous_access" {
  description = "Дозволити анонімний доступ"
  type        = bool
  default     = false
}

variable "storage_size" {
  description = "Розмір сховища для Grafana"
  type        = string
  default     = "10Gi"
}

variable "cpu_request" {
  description = "CPU request для Grafana"
  type        = string
  default     = "100m"
}

variable "memory_request" {
  description = "Memory request для Grafana"
  type        = string
  default     = "128Mi"
}

variable "cpu_limit" {
  description = "CPU limit для Grafana"
  type        = string
  default     = "500m"
}

variable "memory_limit" {
  description = "Memory limit для Grafana"
  type        = string
  default     = "512Mi"
}

variable "prometheus_url" {
  description = "URL Prometheus для підключення як datasource"
  type        = string
  default     = "http://prometheus-kube-prometheus-prometheus.monitoring.svc:80"
}

variable "prometheus_depends_on" {
  description = "Залежність від Prometheus"
  type        = any
  default     = null
}

variable "tags" {
  description = "Теги для ресурсів"
  type        = map(string)
  default     = {}
}
