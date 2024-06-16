output "k8s_namespace" {
  value = kubernetes_namespace.main.metadata[0].name
}