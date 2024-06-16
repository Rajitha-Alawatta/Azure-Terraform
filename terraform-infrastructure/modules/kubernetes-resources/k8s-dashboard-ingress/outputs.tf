output "k8s_dashboard_url" {
  value = kubernetes_ingress_v1.main.spec[0].rule[0].host
}