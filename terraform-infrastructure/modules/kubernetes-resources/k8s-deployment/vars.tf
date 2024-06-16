variable "resource_group_name" {
  type = string
}

variable "kubernetes_cluster_name" {
  type = string
}

variable "k8s_namespace" {
  type = string
}

variable "nginx_image" {
  type = string
}

variable "nginx_container_count" {
  type = string
}

variable "nginx_container_cpu" {
  type = string
}

variable "nginx_container_memory" {
  type = string
}
