# ============================================
# Production Environment Outputs
# ============================================

# VPC Outputs
output "vpc_id" {
  description = "Production VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Production public subnet ID"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "Production private subnet ID"
  value       = module.vpc.private_subnet_id
}

# EC2 Outputs
output "instance_id" {
  description = "Production EC2 instance ID"
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "Production EC2 public IP"
  value       = module.ec2.public_ip
}

output "private_ip" {
  description = "Production EC2 private IP"
  value       = module.ec2.private_ip
}

# IAM Outputs
output "iam_role_arn" {
  description = "Production IAM role ARN"
  value       = module.iam.role_arn
}

output "instance_profile_name" {
  description = "Production IAM instance profile"
  value       = module.iam.instance_profile_name
}

# ECR Outputs
output "ecr_frontend_repository_url" {
  description = "ECR frontend repository URL for docker push"
  value       = module.ecr.frontend_repository_url
}

output "ecr_backend_repository_url" {
  description = "ECR backend repository URL for docker push"
  value       = module.ecr.backend_repository_url
}

# EKS Outputs
output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_certificate_authority" {
  description = "EKS cluster CA data (for kubeconfig)"
  value       = module.eks.cluster_certificate_authority
  sensitive   = true
}

output "eks_node_group_name" {
  description = "EKS node group name"
  value       = module.eks.node_group_name
}
