data "azurerm_kubernetes_cluster" "main" {
  name                = var.kubernetes_cluster_name
  resource_group_name = var.resource_group_name
}
resource "kubernetes_deployment" "main" {
  metadata {
    name      = "sample-nginx-app"
    namespace = var.k8s_namespace
    labels = {
      app = "sample-nginx-app"
    }
  }
  spec {
    replicas = var.nginx_container_count
    selector {
      match_labels = {
        app = "sample-nginx-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "sample-nginx-app"
        }
      }
      spec {
        # Tomcat Container
        container {
          image             = var.nginx_image
          name              = "nginx"
          image_pull_policy = "Always"
          resources {
            limits = {
              cpu    = var.nginx_container_cpu
              memory = var.nginx_container_memory
            }
            requests = {
              cpu    = "250m"
              memory = "128Mi"
            }
          }
          volume_mount {
            mount_path = "/etc/nginx"
            name       = "nginx-storage"
          }
          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            timeout_seconds = 2
            period_seconds  = 5
          }
        }
        volume {
          name = "nginx-storage"
          persistent_volume_claim {
            claim_name = "example-nginx-pvc"
          }
        }
      }
    }
  }
}