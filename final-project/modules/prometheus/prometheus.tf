# Namespace для моніторингу
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
      app  = "monitoring"
    }
  }
}

# Helm реліз Prometheus
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    yamlencode({
      prometheus = {
        prometheusSpec = {
          serviceMonitorSelectorNilUsesHelmValues = false
          serviceMonitorSelector = {}
          serviceMonitorNamespaceSelector = {}
          ruleSelectorNilUsesHelmValues = false
          ruleSelector = {}
          ruleNamespaceSelector = {}
          retention = var.retention
          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "gp2"
                accessModes = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = var.storage_size
                  }
                }
              }
            }
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
        }
        service = {
          type = "LoadBalancer"
          port = 80
        }
      }
      
      grafana = {
        enabled = false  # Використовуємо окремий модуль Grafana
      }
      
      alertmanager = {
        alertmanagerSpec = {
          storage = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "gp2"
                accessModes = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = "2Gi"
                  }
                }
              }
            }
          }
        }
        service = {
          type = "LoadBalancer"
          port = 80
        }
      }
      
      nodeExporter = {
        enabled = true
      }
      
      kubeStateMetrics = {
        enabled = true
      }
      
      kubelet = {
        enabled = true
      }
      
      kubeControllerManager = {
        enabled = true
      }
      
      kubeScheduler = {
        enabled = true
      }
      
      kubeEtcd = {
        enabled = true
      }
      
      kubeProxy = {
        enabled = true
      }
      
      kubeApiServer = {
        enabled = true
      }
    })
  ]

  depends_on = [kubernetes_namespace.monitoring]
}
