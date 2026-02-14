output "resource_group_name" {
  value = module.resource_group.resource_group_name
}

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "acr_login_server" {
  value = module.acr.acr_login_server
}

output "acr_admin_username" {
  value     = module.acr.acr_admin_username
  sensitive = true
}

output "aks_cluster_name" {
  value = module.aks.cluster_name
}

output "aks_cluster_endpoint" {
  value = module.aks.cluster_endpoint
}

output "jenkins_vm_public_ip" {
  value = module.vm.public_ip
}

output "jenkins_vm_private_ip" {
  value = module.vm.private_ip
}

output "connect_to_aks" {
  value = "az aks get-credentials --resource-group ${module.resource_group.resource_group_name} --name ${module.aks.cluster_name}"
}

output "ssh_to_jenkins" {
  value = "ssh ${var.admin_username}@${module.vm.public_ip}"
}
