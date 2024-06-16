resource "helm_release" "kubernetes_dashboard" {
  name             = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard"
  chart            = "kubernetes-dashboard"
  namespace        = "kubernetes-dashboard"
  version          = var.kubernetes_dashboard_version
  create_namespace = true

}