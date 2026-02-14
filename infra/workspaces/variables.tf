variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "ecr_project_name" {
  description = "ECR project name"
  type        = string
  default     = "shop-app"
}

variable "eks_cluster_name" {
  description = "EKS cluster base name (environment will be appended)"
  type        = string
  default     = "shop-eks"
}

variable "s3_bucket_prefix" {
  description = "S3 bucket name prefix"
  type        = string
  default     = "shop-app-bucket"
}
