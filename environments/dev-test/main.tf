module "nginx-sample-app" {
  source = "../../modules/"

  min_node_count          = "1"                    # Kubernetes cluster minimum node count
  max_node_count          = "1"                    # Kubernetes cluster minimum node count
  nginx_pod_count         = "1"                    # DBHawk application replicas - No. of containers
  nginx_image             = "nginx"                # NGINX image
  nginx_container_cpu     = "800m"                 # Tomcat container CPU limit
  nginx_container_memory  = "800m"                 # Database container CPU limit
  environment             = "DevTest"              # Azure resource tags
  k8s_namespace           = "nginx-example-ns"     # Name of the Kubernetes namespace
  resource_group_name     = "test-resource-group"  # Resource group name
  k8s_dashboard_namespace = "kubernetes-dashboard" # Namespace of the Kubernetes dashboard
  storage_account_name    = "tfstatedbhawkdevtest" # Azure storage account name - This can be any name but globally unique
  nginx_app_url           = "xxxxx"                # URL for the NGINX application
  k8s_dashboard_url       = "xxxxx"                # URL for the Kubernetes dashboard

}