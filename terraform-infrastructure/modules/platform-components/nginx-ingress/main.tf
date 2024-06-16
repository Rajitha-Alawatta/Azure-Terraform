resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx-controller"
  namespace        = "nginx-ingress"
  create_namespace = true
  version          = var.nginx_version
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

}