# Helm реліз Grafana
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = var.chart_version
  namespace  = var.namespace

  values = [
    yamlencode({
      adminPassword = var.admin_password
      
      service = {
        type = "LoadBalancer"
        port = 80
        targetPort = 3000
      }
      
      persistence = {
        enabled = true
        storageClassName = "gp2"
        size = var.storage_size
      }
      
      resources = {
        requests = {
          cpu    = var.cpu_request
          memory = var.memory_request
        }
        limits = {
          cpu    = var.cpu_limit
          memory = var.memory_limit
        }
      }
      
      "grafana.ini" = {
        server = {
          domain = var.domain
          root_url = "http://localhost:3000/"
        }
        security = {
          admin_user = var.admin_user
          admin_password = var.admin_password
        }
        "auth.anonymous" = {
          enabled = var.anonymous_access
        }
      }
      
      datasources = {
        "datasources.yaml" = {
          apiVersion = 1
          datasources = [
            {
              name      = "Prometheus"
              type      = "prometheus"
              url       = var.prometheus_url
              access    = "proxy"
              isDefault = true
              editable  = true
            }
          ]
        }
      }
      
      dashboardProviders = {
        "dashboardproviders.yaml" = {
          apiVersion = 1
          providers = [
            {
              name = "default"
              orgId = 1
              folder = ""
              type = "file"
              disableDeletion = false
              editable = true
              options = {
                path = "/var/lib/grafana/dashboards/default"
              }
            }
          ]
        }
      }
      
      dashboards = {
        default = {
          kubernetes-cluster-monitoring = {
            gnetId = 7249
            revision = 1
            datasource = "Prometheus"
          }
          kubernetes-pod-monitoring = {
            gnetId = 6417
            revision = 1
            datasource = "Prometheus"
          }
          node-exporter-full = {
            gnetId = 1860
            revision = 27
            datasource = "Prometheus"
          }
        }
      }
    })
  ]

  depends_on = [var.prometheus_depends_on]
}