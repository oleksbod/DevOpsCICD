output "jenkins_release_name" {
  value = helm_release.jenkins.name
}

output "jenkins_namespace" {
  value = helm_release.jenkins.namespace
}

output "jenkins_service_url" {
  description = "Jenkins service URL"
  value       = "http://jenkins.${helm_release.jenkins.namespace}.svc.cluster.local:8080"
}

output "admin_password_command" {
  description = "Command to get Jenkins admin password"
  value       = "kubectl -n ${helm_release.jenkins.namespace} get secret jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 -d"
}
