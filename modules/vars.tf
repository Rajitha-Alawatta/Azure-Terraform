variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "min_node_count" {
  type = string
}

variable "max_node_count" {
  type = string
}

variable "k8s_namespace" {
  type = string
}

variable "nginx_container_cpu" {
  type = string
}

variable "nginx_container_memory" {
  type = string
}

variable "nginx_pod_count" {
  type = string
}

variable "nginx_app_url" {
  type = string
}

variable "k8s_dashboard_url" {
  type = string
}

variable "k8s_dashboard_namespace" {
  type = string
}

variable "nginx_image" {
  type = string
}