output "loadbalanbcer_ip" {
  value = module.nginx-sample-app.loadbalanbcer_ip
}

output "nginx_app_url" {
  value = module.nginx-sample-app.nginx_app_url
}

output "k8s_dashboard_url" {
  value = module.nginx-sample-app.kubernetes_dashboard_url
}

output "resource_group" {
  value = module.nginx-sample-app.resource_group
}

output "aks_cluster_name" {
  value = module.nginx-sample-app.aks_cluster_name
}

output "Terraform_NGINX_App" {

  value = <<EOT

  Terraform has successfully created all the resources!

  Please create the 'A' records in DNS for NGINX application and Kubernetes dashboard.

  * The NGINX app URL is ${module.nginx-sample-app.nginx_app_url} and the IP is ${module.nginx-sample-app.loadbalanbcer_ip}
  * The Kubernetes dashboard URL is ${module.nginx-sample-app.kubernetes_dashboard_url} and the IP is ${module.nginx-sample-app.loadbalanbcer_ip}

  -----------------------------------------------------------------------------------------------------------------------------------------------

  Login to your AKS cluster using the below commands.

  * az account set --subscription 28dbd8be-c6be-4088-8ae0-e50579160854
  * az aks get-credentials --resource-group ${module.nginx-sample-app.resource_group} --name ${module.nginx-sample-app.aks_cluster_name} --overwrite-existing

  -----------------------------------------------------------------------------------------------------------------------------------------------

  * Access your NGINX application using https://${module.nginx-sample-app.nginx_app_url}
  * Access your Kubernetes dashboard using https://${module.nginx-sample-app.kubernetes_dashboard_url}

  -----------------------------------------------------------------------------------------------------------------------------------------------

  * Run "kubectl -n kubernetes-dashboard create token kubernetes-dashboard" to get the token

  -----------------------------------------------------------------------------------------------------------------------------------------------
EOT
}