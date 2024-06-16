terraform {
  required_version = "1.3.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.93.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.49.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.27.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path            = "~/.kube/config" # For local authentication
    host                   = data.azurerm_kubernetes_cluster.main.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.main.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  config_path            = "~/.kube/config" # For local authentication
  host                   = data.azurerm_kubernetes_cluster.main.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.main.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
}

provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.main.kube_config[0].host
  client_key             = base64decode(data.azurerm_kubernetes_cluster.main.kube_config[0].client_key)
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.main.kube_config[0].client_certificate)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)
}