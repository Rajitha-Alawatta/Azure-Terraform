data "azurerm_kubernetes_cluster" "main" {
  name                = var.kubernetes_cluster_name
  resource_group_name = var.resource_group_name
}

resource "kubernetes_ingress_v1" "main" {
  metadata {
    name      = "k8s-dashboard-ingress"
    namespace = var.k8s_dashboard_namespace
    annotations = {
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-production"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/ssl-passthrough"    = "true"
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTPS"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = var.k8s_dashboard_ingress_url
      http {
        path {
          backend {
            service {
              name = "kubernetes-dashboard"
              port {
                number = 443
              }
            }
          }
          path = "/"
        }
      }
    }
    tls {
      secret_name = "k8s-dashboard-tls"
      hosts       = [var.k8s_dashboard_ingress_url]
    }
  }
}