data "azurerm_kubernetes_cluster" "main" {
  name                = var.kubernetes_cluster_name
  resource_group_name = var.resource_group_name
}

resource "kubernetes_ingress_v1" "main" {
  metadata {
    name      = "nginx-ingress"
    namespace = var.k8s_namespace
    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-production"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = var.ingress_url
      http {
        path {
          backend {
            service {
              name = "nginx"
              port {
                number = 8080
              }
            }
          }
          path = "/"
        }
      }
    }
    tls {
      secret_name = "nginx-tls"
      hosts       = [var.ingress_url]
    }
  }
}