output "grafana_service_name" {
  description = "Назва сервісу Grafana"
  value       = "grafana"
}

output "grafana_service_port" {
  description = "Порт сервісу Grafana"
  value       = 80
}

output "grafana_ui_command" {
  description = "Команда для доступу до Grafana UI"
  value       = "kubectl port-forward svc/grafana 3000:80 -n monitoring"
}

output "grafana_admin_user" {
  description = "Користувач адміністратора Grafana"
  value       = var.admin_user
}

output "grafana_admin_password" {
  description = "Пароль адміністратора Grafana"
  value       = var.admin_password
  sensitive   = true
}

output "grafana_url" {
  description = "URL для доступу до Grafana"
  value       = "http://localhost:3000"
}
