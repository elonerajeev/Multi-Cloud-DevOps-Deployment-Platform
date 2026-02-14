# Multi-Environment Deployment with Terraform Workspaces

## 🎯 Overview

This setup uses **Terraform Workspaces** to manage multiple environments (dev, stage, prod) with a single codebase.

## 📊 Environment Configurations

| Environment | Instance Type | EKS Nodes | Min Nodes | Max Nodes | Disk Size | Cost/Month |
|-------------|---------------|-----------|-----------|-----------|-----------|------------|
| **dev**     | t3.small      | 1         | 1         | 2         | 20 GB     | ~$50       |
| **stage**   | t3.medium     | 2         | 1         | 3         | 25 GB     | ~$100      |
| **prod**    | t3.large      | 3         | 2         | 5         | 30 GB     | ~$200      |

## 🚀 Quick Start

### 1. Initialize Terraform

```bash
cd infra/workspaces
terraform init
```

### 2. Deploy to Dev

```bash
./deploy.sh dev apply
```

### 3. Deploy to Staging

```bash
./deploy.sh stage apply
```

### 4. Deploy to Production

```bash
./deploy.sh prod apply
```

## 📝 Manual Commands

### Create/Select Workspace

```bash
# Create new workspace
terraform workspace new dev

# List workspaces
terraform workspace list

# Select workspace
terraform workspace select prod

# Show current workspace
terraform workspace show
```

### Deploy to Specific Environment

```bash
# Plan changes
terraform workspace select dev
terraform plan

# Apply changes
terraform apply

# Destroy environment
terraform destroy
```

## 🔄 Workflow

### Development Flow

```bash
# 1. Work on dev
./deploy.sh dev apply

# 2. Test changes
kubectl get pods -n shop

# 3. Promote to staging
./deploy.sh stage apply

# 4. Final testing
# Run integration tests

# 5. Deploy to production
./deploy.sh prod apply
```

### Quick Commands

```bash
# Preview dev changes
./deploy.sh dev plan

# Deploy to staging
./deploy.sh stage apply

# View prod outputs
./deploy.sh prod output

# Destroy dev environment
./deploy.sh dev destroy
```

## 📂 State Management

Each workspace has its own state file:

```
S3: rajeev-terraform-state-bucket-12345
├── environments/dev/terraform.tfstate
├── environments/stage/terraform.tfstate
└── environments/prod/terraform.tfstate
```

## 🔐 Resource Naming

Resources are automatically named with environment suffix:

- **EKS Cluster**: `shop-eks-dev`, `shop-eks-stage`, `shop-eks-prod`
- **EC2 Instance**: `dev-jenkins-server`, `stage-jenkins-server`, `prod-jenkins-server`
- **S3 Bucket**: `shop-app-bucket-dev`, `shop-app-bucket-stage`, `shop-app-bucket-prod`

## 🎛️ Configuration

### Shared Variables (terraform.tfvars)

```hcl
region   = "us-east-1"
ami_id   = "ami-0c55b159cbfafe1f0"
key_name = "your-key-pair-name"
```

### Environment-Specific (main.tf locals)

```hcl
dev = {
  instance_type    = "t3.small"
  eks_node_count   = 1
  eks_min_nodes    = 1
  eks_max_nodes    = 2
  root_volume_size = 20
}
```

## 🔧 Customization

To change environment configs, edit `infra/workspaces/main.tf`:

```hcl
locals {
  env_config = {
    dev = {
      instance_type    = "t3.micro"  # Change this
      eks_node_count   = 1
      # ...
    }
  }
}
```

## 📊 View Current Environment

```bash
# Show current workspace
terraform workspace show

# Show environment config
terraform output environment_config
```

## 🌐 Connect to Environments

### Dev

```bash
terraform workspace select dev
aws eks update-kubeconfig --name shop-eks-dev --region us-east-1
kubectl get nodes
```

### Staging

```bash
terraform workspace select stage
aws eks update-kubeconfig --name shop-eks-stage --region us-east-1
kubectl get nodes
```

### Production

```bash
terraform workspace select prod
aws eks update-kubeconfig --name shop-eks-prod --region us-east-1
kubectl get nodes
```

## 🚨 Safety Features

1. **Separate State Files**: Each environment has isolated state
2. **Confirmation Required**: Destroy requires typing environment name
3. **Workspace Validation**: Script validates environment names
4. **Auto-naming**: Resources automatically tagged with environment

## 💡 Best Practices

### 1. Always Check Current Workspace

```bash
terraform workspace show
```

### 2. Use the Deploy Script

```bash
./deploy.sh <env> <action>  # Safer than manual commands
```

### 3. Test in Dev First

```bash
./deploy.sh dev apply    # Test here first
./deploy.sh stage apply  # Then staging
./deploy.sh prod apply   # Finally production
```

### 4. Review Plans Before Apply

```bash
./deploy.sh prod plan  # Always review before production deploy
```

## 🔄 Migration from Old Structure

If you have existing `infra/environments/prod/`:

```bash
# 1. Import existing resources (optional)
cd infra/workspaces
terraform workspace new prod
terraform import module.vpc.aws_vpc.main <vpc-id>
# ... import other resources

# 2. Or start fresh
./deploy.sh prod apply
```

## 📈 Scaling

### Add New Environment

Edit `main.tf` and add to `env_config`:

```hcl
qa = {
  instance_type    = "t3.small"
  eks_node_count   = 1
  eks_min_nodes    = 1
  eks_max_nodes    = 2
  root_volume_size = 20
}
```

Then deploy:

```bash
./deploy.sh qa apply
```

## 🧹 Cleanup

### Destroy Single Environment

```bash
./deploy.sh dev destroy
```

### Destroy All Environments

```bash
./deploy.sh dev destroy
./deploy.sh stage destroy
./deploy.sh prod destroy
```

## 📞 Troubleshooting

### Wrong Workspace

```bash
# Check current workspace
terraform workspace show

# Switch to correct one
terraform workspace select prod
```

### State Lock Issues

```bash
# Force unlock (use carefully)
terraform force-unlock <lock-id>
```

### Resource Already Exists

```bash
# Import existing resource
terraform import module.eks.aws_eks_cluster.main shop-eks-prod
```

## ✅ Advantages Over Separate Directories

1. ✅ Single codebase to maintain
2. ✅ Consistent configuration across environments
3. ✅ Easy to add new environments
4. ✅ Less code duplication
5. ✅ Automatic environment-specific naming
6. ✅ Isolated state files
7. ✅ Simple deployment script

## 🎯 Summary

```bash
# Deploy to dev
./deploy.sh dev apply

# Deploy to staging
./deploy.sh stage apply

# Deploy to production
./deploy.sh prod apply

# That's it! 🚀
```
