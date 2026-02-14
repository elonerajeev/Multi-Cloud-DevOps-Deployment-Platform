#!/bin/bash

# ============================================
# Multi-Environment Deployment Script
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if environment is provided
if [ -z "$1" ]; then
    print_error "Usage: ./deploy.sh <environment> [action]"
    echo ""
    echo "Environments: dev, stage, prod"
    echo "Actions: plan, apply, destroy, output"
    echo ""
    echo "Examples:"
    echo "  ./deploy.sh dev plan      # Preview dev environment"
    echo "  ./deploy.sh prod apply    # Deploy to production"
    echo "  ./deploy.sh stage destroy # Destroy staging"
    exit 1
fi

ENVIRONMENT=$1
ACTION=${2:-plan}

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|stage|prod)$ ]]; then
    print_error "Invalid environment: $ENVIRONMENT"
    echo "Valid environments: dev, stage, prod"
    exit 1
fi

# Validate action
if [[ ! "$ACTION" =~ ^(plan|apply|destroy|output|init)$ ]]; then
    print_error "Invalid action: $ACTION"
    echo "Valid actions: init, plan, apply, destroy, output"
    exit 1
fi

print_header "Deploying to: $ENVIRONMENT"

# Initialize Terraform if needed
if [ ! -d ".terraform" ] || [ "$ACTION" == "init" ]; then
    print_header "Initializing Terraform"
    terraform init
    print_success "Terraform initialized"
fi

# Create or select workspace
print_header "Setting up workspace: $ENVIRONMENT"
terraform workspace select $ENVIRONMENT 2>/dev/null || terraform workspace new $ENVIRONMENT
print_success "Workspace: $(terraform workspace show)"

# Execute action
case $ACTION in
    plan)
        print_header "Planning changes for $ENVIRONMENT"
        terraform plan -var-file=terraform.tfvars
        ;;
    apply)
        print_header "Applying changes to $ENVIRONMENT"
        print_warning "This will create/modify resources in AWS"
        read -p "Continue? (yes/no): " confirm
        if [ "$confirm" == "yes" ]; then
            terraform apply -var-file=terraform.tfvars -auto-approve
            print_success "Deployment complete!"
            echo ""
            print_header "Outputs"
            terraform output
            echo ""
            print_success "Configure kubectl:"
            echo "  $(terraform output -raw configure_kubectl)"
        else
            print_warning "Deployment cancelled"
        fi
        ;;
    destroy)
        print_header "Destroying $ENVIRONMENT environment"
        print_error "WARNING: This will DELETE all resources!"
        read -p "Type '$ENVIRONMENT' to confirm: " confirm
        if [ "$confirm" == "$ENVIRONMENT" ]; then
            terraform destroy -var-file=terraform.tfvars -auto-approve
            print_success "Environment destroyed"
        else
            print_warning "Destruction cancelled"
        fi
        ;;
    output)
        print_header "Outputs for $ENVIRONMENT"
        terraform output
        ;;
esac

print_success "Done!"
