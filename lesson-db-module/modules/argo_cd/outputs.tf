output "argo_cd_server_service" {
  description = "Argo CD server service"
  value       = "argo-cd.${var.namespace}.svc.cluster.local"
}

output "admin_password" {
  description = "Initial admin password"
  value       = "Run: kubectl -n ${var.namespace} get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d"
}

output "argo_cd_url" {
  description = "Argo CD UI URL"
  value       = "kubectl get svc -n ${var.namespace} argo-cd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}
