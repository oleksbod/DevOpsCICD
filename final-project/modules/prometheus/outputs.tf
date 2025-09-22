output "prometheus_namespace" {
  description = "Namespace Prometheus"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "prometheus_service_name" {
  description = "Назва сервісу Prometheus"
  value       = "prometheus-kube-prometheus-prometheus"
}

output "prometheus_service_port" {
  description = "Порт сервісу Prometheus"
  value       = 80
}

output "prometheus_ui_command" {
  description = "Команда для доступу до Prometheus UI"
  value       = "kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:80 -n monitoring"
}

output "alertmanager_service_name" {
  description = "Назва сервісу Alertmanager"
  value       = "prometheus-kube-prometheus-alertmanager"
}

output "alertmanager_ui_command" {
  description = "Команда для доступу до Alertmanager UI"
  value       = "kubectl port-forward svc/prometheus-kube-prometheus-alertmanager 9093:80 -n monitoring"
}
