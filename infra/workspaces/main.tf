# ============================================
# Multi-Environment with Terraform Workspaces
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
    bucket         = "rajeev-terraform-state-bucket-12345"
    key            = "shop-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
    
    # Workspace-specific state files
    workspace_key_prefix = "environments"
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
# Local Variables (Environment-specific)
# ============================================
locals {
  environment = terraform.workspace
  
  # Environment-specific configurations
  env_config = {
    dev = {
      instance_type    = "t3.small"
      eks_node_count   = 1
      eks_min_nodes    = 1
      eks_max_nodes    = 2
      root_volume_size = 20
    }
    stage = {
      instance_type    = "t3.medium"
      eks_node_count   = 2
      eks_min_nodes    = 1
      eks_max_nodes    = 3
      root_volume_size = 25
    }
    prod = {
      instance_type    = "t3.large"
      eks_node_count   = 3
      eks_min_nodes    = 2
      eks_max_nodes    = 5
      root_volume_size = 30
    }
  }
  
  # Get current environment config
  current_env = local.env_config[local.environment]
}

# ============================================
# VPC Module
# ============================================
module "vpc" {
  source     = "../modules/vpc"
  cidr_block = var.cidr_block
  region     = var.region
}

# ============================================
# IAM Module
# ============================================
module "iam" {
  source      = "../modules/iam"
  role_name   = "${local.environment}-ec2-role"
  policy_name = "${local.environment}-ec2-policy"
  environment = local.environment
}

# ============================================
# EC2 Module (Jenkins)
# ============================================
module "ec2" {
  source               = "../modules/ec2"
  ami_id               = var.ami_id
  instance_type        = local.current_env.instance_type
  key_name             = var.key_name
  vpc_id               = module.vpc.vpc_id
  subnet_id            = module.vpc.public_subnet_id
  instance_name        = "${local.environment}-jenkins-server"
  environment          = local.environment
  iam_instance_profile = module.iam.instance_profile_name
  root_volume_size     = local.current_env.root_volume_size
}

# ============================================
# ECR Module
# ============================================
module "ecr" {
  source       = "../modules/ecr"
  project_name = var.ecr_project_name
  environment  = local.environment
}

# ============================================
# EKS Module
# ============================================
module "eks" {
  source             = "../modules/eks"
  cluster_name       = "${var.eks_cluster_name}-${local.environment}"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  node_desired_size  = local.current_env.eks_node_count
  node_min_size      = local.current_env.eks_min_nodes
  node_max_size      = local.current_env.eks_max_nodes
  node_instance_type = local.current_env.instance_type
  environment        = local.environment
}

# ============================================
# S3 Module
# ============================================
module "s3" {
  source      = "../modules/s3"
  bucket_name = "${var.s3_bucket_prefix}-${local.environment}"
  environment = local.environment
}
