# ============================================
# Production Environment - Main Configuration
# ============================================

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket         = "rajeev-terraform-state-1771131682-396ee83a"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name,
        "--region",
        var.region
      ]
    }
  }
}

# ============================================
# VPC Module
# ============================================
module "vpc" {
  source     = "../../modules/vpc"
  cidr_block = var.cidr_block
  region     = var.region
}

# ============================================
# IAM Module (EC2 roles)
# ============================================
module "iam" {
  source      = "../../modules/iam"
  role_name   = "${var.environment}-ec2-role"
  policy_name = "${var.environment}-ec2-policy"
  environment = var.environment
}

# ============================================
# EC2 Module
# ============================================
module "ec2" {
  source               = "../../modules/ec2"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  vpc_id               = module.vpc.vpc_id
  subnet_id            = module.vpc.public_subnet_id
  instance_name        = "${var.environment}-app-server"
  environment          = var.environment
  iam_instance_profile = module.iam.instance_profile_name
  root_volume_size     = var.root_volume_size
}

# ============================================
# ECR Module
# ============================================
module "ecr" {
  source       = "../../modules/ecr"
  project_name = var.ecr_project_name
  environment  = var.environment
}

# ============================================
# EKS Module
# ============================================
module "eks" {
  source             = "../../modules/eks"
  cluster_name       = var.eks_cluster_name
  cluster_version    = var.eks_cluster_version
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  node_instance_type = var.eks_node_instance_type
  node_desired_size  = var.eks_node_desired_size
  node_min_size      = var.eks_node_min_size
  node_max_size      = var.eks_node_max_size
  node_disk_size     = var.eks_node_disk_size
  environment        = var.environment
}
