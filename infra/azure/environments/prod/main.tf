# ============================================
# Azure Production Environment - Main Configuration
# ============================================

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "rajeevtfstate12345"  # Must be globally unique
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    host                   = module.aks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
    client_certificate     = base64decode(module.aks.kube_config[0].client_certificate)
    client_key             = base64decode(module.aks.kube_config[0].client_key)
  }
}

# ============================================
# Resource Group
# ============================================
module "resource_group" {
  source              = "../../modules/resource-group"
  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
}

# ============================================
# Virtual Network
# ============================================
module "vnet" {
  source              = "../../modules/vnet"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  environment         = var.environment
  vnet_cidr           = var.vnet_cidr
  aks_subnet_cidr     = var.aks_subnet_cidr
  vm_subnet_cidr      = var.vm_subnet_cidr
}

# ============================================
# Azure Container Registry
# ============================================
module "acr" {
  source              = "../../modules/acr"
  acr_name            = var.acr_name
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  environment         = var.environment
}

# ============================================
# Azure Kubernetes Service
# ============================================
module "aks" {
  source              = "../../modules/aks"
  cluster_name        = var.aks_cluster_name
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  kubernetes_version  = var.kubernetes_version
  node_count          = var.node_count
  min_node_count      = var.min_node_count
  max_node_count      = var.max_node_count
  vm_size             = var.aks_vm_size
  subnet_id           = module.vnet.aks_subnet_id
  environment         = var.environment
  acr_id              = module.acr.acr_id
}

# ============================================
# Jenkins VM
# ============================================
module "vm" {
  source              = "../../modules/vm"
  vm_name             = "${var.environment}-jenkins-vm"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  vm_size             = var.jenkins_vm_size
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  subnet_id           = module.vnet.vm_subnet_id
  nsg_id              = module.vnet.nsg_id
  disk_size_gb        = var.disk_size_gb
  environment         = var.environment
}
