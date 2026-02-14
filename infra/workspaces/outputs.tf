output "environment" {
  description = "Current workspace/environment"
  value       = local.environment
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "ecr_repository_urls" {
  description = "ECR repository URLs"
  value       = module.ecr.repository_urls
}

output "jenkins_public_ip" {
  description = "Jenkins EC2 public IP"
  value       = module.ec2.public_ip
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.s3.bucket_name
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}"
}

output "ssh_to_jenkins" {
  description = "SSH command for Jenkins server"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${module.ec2.public_ip}"
}

output "environment_config" {
  description = "Current environment configuration"
  value = {
    instance_type    = local.current_env.instance_type
    eks_node_count   = local.current_env.eks_node_count
    eks_min_nodes    = local.current_env.eks_min_nodes
    eks_max_nodes    = local.current_env.eks_max_nodes
    root_volume_size = local.current_env.root_volume_size
  }
}
