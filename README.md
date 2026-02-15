# 🚀 Multi-Cloud DevOps Deployment Platform

A production-ready, enterprise-grade e-commerce application with automated CI/CD pipeline, multi-environment support, and comprehensive monitoring. Deploy to AWS or Azure with a single command.

[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](https://opensource.org/licenses/ISC)
[![Terraform](https://img.shields.io/badge/Terraform-1.0+-purple.svg)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28-blue.svg)](https://kubernetes.io/)
[![AWS](https://img.shields.io/badge/AWS-EKS-orange.svg)](https://aws.amazon.com/eks/)
[![Azure](https://img.shields.io/badge/Azure-AKS-blue.svg)](https://azure.microsoft.com/en-us/services/kubernetes-service/)

---

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#️-architecture)
- [Tech Stack](#️-tech-stack)
- [Project Structure](#-project-structure)
- [Quick Start](#-quick-start)
- [Multi-Environment Deployment](#-multi-environment-deployment)
- [Multi-Cloud Support](#️-multi-cloud-support)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Monitoring](#-monitoring)
- [Available Commands](#-available-commands)
- [Configuration](#️-configuration)
- [Security](#-security)
- [Cost Estimation](#-cost-estimation)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- **[How to create dev branch & open PR](HOW-TO-DEV-BRANCH-AND-PR.md)** (step-by-step)

---

## ✨ Features

### 🎯 Core Features
- ✅ **Full-Stack E-Commerce Application** - React frontend + Node.js backend
- ✅ **Multi-Environment Support** - Dev, Staging, Production with Terraform Workspaces
- ✅ **Multi-Cloud Ready** - Deploy to AWS EKS or Azure AKS
- ✅ **Automated CI/CD** - Jenkins pipeline with GitHub integration
- ✅ **Container Orchestration** - Kubernetes with auto-scaling (HPA)
- ✅ **Infrastructure as Code** - Terraform modules for reproducible deployments
- ✅ **Comprehensive Monitoring** - Prometheus + Grafana dashboards
- ✅ **Security Scanning** - Trivy for container vulnerability detection
- ✅ **Zero-Downtime Deployments** - Rolling updates with health checks

### 🔧 DevOps Features
- 🔄 **GitOps Workflow** - Push to GitHub → Auto-deploy
- 📊 **Real-time Monitoring** - Application and infrastructure metrics
- 🔐 **Secrets Management** - Kubernetes secrets + AWS Secrets Manager ready
- 🌐 **Load Balancing** - AWS ELB / Azure Load Balancer
- 📈 **Auto-Scaling** - Horizontal Pod Autoscaler (HPA)
- 🔍 **Centralized Logging** - Ready for ELK/EFK stack integration
- 🚨 **Alerting** - Prometheus AlertManager configuration

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         GitHub Repository                        │
└────────────────────────────┬────────────────────────────────────┘
                             │ Push/Webhook
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Jenkins CI/CD Server                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │  Build   │→ │  Test    │→ │  Scan    │→ │  Deploy  │       │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘       │
└────────────────────────────┬────────────────────────────────────┘
                             │
                ┌────────────┴────────────┐
                ▼                         ▼
    ┌───────────────────┐     ┌───────────────────┐
    │   AWS ECR/ACR     │     │   Kubernetes      │
    │ Container Registry│     │   Cluster (EKS)   │
    └───────────────────┘     └─────────┬─────────┘
                                        │
                    ┌───────────────────┼───────────────────┐
                    ▼                   ▼                   ▼
            ┌───────────┐       ┌───────────┐     ┌───────────┐
            │  Backend  │       │ Frontend  │     │Monitoring │
            │   Pods    │       │   Pods    │     │  Stack    │
            └─────┬─────┘       └─────┬─────┘     └───────────┘
                  │                   │
                  └─────────┬─────────┘
                            ▼
                    ┌───────────────┐
                    │ Load Balancer │
                    └───────┬───────┘
                            ▼
                    ┌───────────────┐
                    │     Users     │
                    └───────────────┘
```

---

## 🛠️ Tech Stack

### Infrastructure
| Technology | Version | Purpose |
|------------|---------|---------|
| Terraform | 1.0+ | IaC |
| Kubernetes | 1.28 | Orchestration |
| AWS EKS | Latest | Managed K8s |
| Azure AKS | Latest | Managed K8s |
| Docker | Latest | Containerization |

### DevOps
| Technology | Version | Purpose |
|------------|---------|---------|
| Jenkins | Latest | CI/CD |
| Prometheus | Latest | Metrics |
| Grafana | Latest | Visualization |
| Trivy | 0.48+ | Security Scanning |

---

## 📁 Project Structure

```
Multi-Cloud-DevOps-Deployment-Platform/
│
├── app/                          # Application Code
│   ├── backend/                  # Node.js Express API
│   │   ├── controller/           # Business logic
│   │   ├── models/               # MongoDB schemas
│   │   ├── routes/               # API routes
│   │   ├── middleware/           # Auth, validation
│   │   ├── Dockerfile.prod       # Production Docker image
│   │   └── package.json
│   │
│   └── frontend/                 # React Application
│       ├── src/                  # Source code
│       ├── public/               # Static assets
│       ├── Dockerfile.prod       # Production Docker image
│       └── package.json
│
├── infra/                        # Infrastructure as Code
│   ├── modules/                  # Reusable Terraform modules
│   │   ├── vpc/                  # AWS VPC
│   │   ├── eks/                  # AWS EKS cluster
│   │   ├── ecr/                  # Container registry
│   │   ├── ec2/                  # Jenkins server
│   │   ├── iam/                  # IAM roles/policies
│   │   └── s3/                   # S3 buckets
│   │
│   ├── workspaces/               # Multi-Environment (NEW!)
│   │   ├── main.tf               # Workspace-based config
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── deploy.sh             # Deployment script
│   │   └── README.md
│   │
│   ├── environments/             # Legacy: Separate environments
│   │   ├── dev/
│   │   ├── stage/
│   │   └── prod/
│   │
│   ├── azure/                    # Azure Infrastructure (NEW!)
│   │   ├── modules/              # Azure-specific modules
│   │   │   ├── aks/              # Azure Kubernetes Service
│   │   │   ├── acr/              # Azure Container Registry
│   │   │   ├── vnet/             # Virtual Network
│   │   │   └── vm/               # Virtual Machine
│   │   └── environments/
│   │       └── prod/
│   │
│   └── backend/                  # Terraform state backend
│       └── backend.tf
│
├── k8s/                          # Kubernetes Manifests
│   ├── namespace.yaml            # Namespace definition
│   ├── configmap.yaml            # Configuration
│   ├── secret.yaml               # Secrets (template)
│   ├── ingress.yaml              # Ingress rules
│   ├── network-policy.yaml       # Pod-to-pod traffic restrictions
│   │
│   ├── backend/                  # Backend K8s resources
│   │   ├── deployment.yaml       # Deployment spec
│   │   ├── service.yaml          # Service (LoadBalancer)
│   │   └── hpa.yaml              # Horizontal Pod Autoscaler
│   │
│   └── frontend/                 # Frontend K8s resources
│       ├── deployment.yaml
│       ├── service.yaml
│       └── hpa.yaml
│
├── monitoring/                   # Monitoring Stack
│   ├── prometheus/               # Prometheus configs
│   ├── grafana/                  # Grafana dashboards
│   └── README.md
│
├── scripts/                      # Automation Scripts
│   ├── setup-terraform-backend.sh
│
├── .github/workflows/ci.yml      # GitHub Actions CI (build, test, Docker)
├── docker-compose.yml            # Local dev: backend + frontend + MongoDB
├── Jenkinsfile                   # AWS CI/CD Pipeline
├── Jenkinsfile.azure             # Azure CI/CD Pipeline
├── Makefile                      # Task automation
└── README.md                     # This file
```

---

## 🚀 Quick Start

### Run locally with Docker Compose (no cloud required)
```bash
docker compose up --build
# Frontend: http://localhost:3000  |  Backend: http://localhost:5000  |  Mongo: localhost:27017
```

### Prerequisites

Before you begin, ensure you have:

- ✅ **AWS Account** with admin access
- ✅ **AWS CLI** configured (`aws configure`)
- ✅ **Terraform** >= 1.0.0 installed
- ✅ **kubectl** installed
- ✅ **Docker** installed and running
- ✅ **Git** installed
- ✅ **SSH Key Pair** created in AWS

### 1️⃣ Clone Repository

```bash
git clone https://github.com/elonerajeev/Multi-Cloud-DevOps-Deployment-Platform.git
cd Multi-Cloud-DevOps-Deployment-Platform
```

### 2️⃣ Setup Terraform Backend

```bash
# Create S3 bucket and DynamoDB table for state management
./scripts/setup-terraform-backend.sh
```

### 3️⃣ Configure Variables

Edit `infra/workspaces/terraform.tfvars`:

```hcl
region   = "us-east-1"
ami_id   = "ami-0c55b159cbfafe1f0"  # Update for your region
key_name = "your-key-pair-name"     # Your AWS key pair
```

### 4️⃣ Deploy Infrastructure

### 5️⃣ Configure kubectl

```bash
# Connect to EKS cluster
aws eks update-kubeconfig --name shop-eks-dev --region us-east-1

# Verify connection
kubectl get nodes
```

### 6️⃣ Setup Jenkins

See [DEPLOYMENT_GUIDE.txt](DEPLOYMENT_GUIDE.txt) for detailed Jenkins setup.

Quick steps:
```bash
# Get Jenkins server IP
terraform output jenkins_public_ip

# SSH to server
ssh ec2-user@<jenkins-ip>

# Follow installation steps in DEPLOYMENT_GUIDE.txt
```

### 7️⃣ Deploy Application

**Option A: Via Jenkins (Recommended)**
- Push code to GitHub
- Jenkins automatically builds and deploys

**Option B: Manual Deployment**
```bash
make docker-build
make docker-push
make k8s-deploy
```

### 8️⃣ Access Application

```bash
# Get application URLs
make get-urls

# Or manually
kubectl get svc -n shop
```

---

## 🌍 Multi-Environment Deployment

Deploy to **dev**, **staging**, or **production** with different resource configurations.

### Environment Configurations

| Environment | Instance Type | EKS Nodes | Min/Max Nodes | Disk | Cost/Month |
|-------------|---------------|-----------|---------------|------|------------|
| **dev**     | t3.small      | 1         | 1-2           | 20GB | ~$50       |
| **stage**   | t3.medium     | 2         | 1-3           | 25GB | ~$100      |
| **prod**    | t3.large      | 3         | 2-5           | 30GB | ~$200      |

### Deployment Commands

```bash
# Deploy to development
make deploy-dev

# Deploy to staging
make deploy-stage

# Deploy to production
make deploy-prod

# Preview changes before applying
make plan-dev
make plan-stage
make plan-prod
```

### Manual Workspace Management

```bash
cd infra/workspaces

# List workspaces
terraform workspace list

# Select workspace
terraform workspace select prod

# Deploy
terraform apply
```

### Workflow Example

```bash
# 1. Develop and test in dev
make deploy-dev
# Test features...

# 2. Promote to staging
make deploy-stage
# Run integration tests...

# 3. Deploy to production
make deploy-prod
# Monitor metrics...
```

📖 **Full Guide**: [infra/workspaces/README.md](infra/workspaces/README.md)

---

## ☁️ Multi-Cloud Support

Deploy the same application to **AWS** or **Azure** (or both!).

### AWS Deployment (Default)

```bash
# Deploy to AWS EKS
cd infra/workspaces
./deploy.sh prod apply

# Use Jenkinsfile for CI/CD
```

### Azure Deployment

```bash
# Deploy to Azure AKS
cd infra/azure/environments/prod
terraform init
terraform apply

# Use Jenkinsfile.azure for CI/CD
```

### Cloud Comparison

| Feature | AWS | Azure |
|---------|-----|-------|
| Kubernetes | EKS | AKS |
| Container Registry | ECR | ACR |
| VM for Jenkins | EC2 | Virtual Machine |
| Networking | VPC | VNet |
| Cost (2 nodes) | ~$120/mo | ~$100/mo |

📖 **Azure Guide**: [AZURE_DEPLOYMENT_GUIDE.md](AZURE_DEPLOYMENT_GUIDE.md)

---

## 🔄 CI/CD Pipeline

### Pipeline Stages

```
┌─────────────┐
│  Checkout   │  Pull code from GitHub
└──────┬──────┘
       │
┌──────▼──────┐
│Build Images │  Docker build (parallel: frontend + backend)
└──────┬──────┘
       │
┌──────▼──────┐
│Security Scan│  Trivy vulnerability scanning
└──────┬──────┘
       │
┌──────▼──────┐
│  Push ECR   │  Push images to container registry
└──────┬──────┘
       │
┌──────▼──────┐
│Deploy to K8s│  Apply Kubernetes manifests
└──────┬──────┘
       │
┌──────▼──────┐
│Health Check │  Verify deployment success
└──────┬──────┘
       │
┌──────▼──────┐
│  Get URLs   │  Display application URLs
└─────────────┘
```

### Trigger Options

**1. Automatic (GitHub Webhook)**
```bash
# Push to main branch
git push origin main
# Jenkins automatically deploys
```

**2. Manual (Jenkins UI)**
- Go to Jenkins → Select job → "Build Now"

**3. Scheduled (Cron)**
```groovy
triggers {
    cron('H 2 * * *')  // Daily at 2 AM
}
```

### Pipeline Features

- ✅ Parallel builds (frontend + backend)
- ✅ Security scanning with Trivy
- ✅ Automatic rollback on failure
- ✅ Health checks after deployment
- ✅ Slack/Email notifications (configurable)
- ✅ Build artifacts archiving

---

## 📊 Monitoring

### Prometheus + Grafana Stack

**Access Grafana Dashboard:**
```bash
# Get Grafana URL
make grafana-url

# Or manually
kubectl get svc -n monitoring monitoring-grafana

# Default credentials
Username: admin
Password: admin123
```

### Available Metrics

- 📈 **Application Metrics**
  - Request rate, latency, errors
  - API endpoint performance
  - Database query times

- 🖥️ **Infrastructure Metrics**
  - CPU, memory, disk usage
  - Network I/O
  - Pod status and restarts

- ☸️ **Kubernetes Metrics**
  - Node health
  - Pod resource usage
  - Deployment status

### Pre-configured Dashboards

1. **Kubernetes Cluster Overview**
2. **Node Exporter Full**
3. **Application Performance**
4. **Container Metrics**

### Alerts (Optional)

Configure AlertManager for:
- High CPU/Memory usage
- Pod crash loops
- API error rate spikes
- Disk space warnings

---

## 🛠️ Available Commands

### Quick Reference

```bash
make help              # Show all available commands
```

### Infrastructure

```bash
# Multi-environment (Workspaces)
make deploy-dev        # Deploy to dev
make deploy-stage      # Deploy to staging
make deploy-prod       # Deploy to production
make plan-dev          # Preview dev changes
make destroy-dev       # Destroy dev environment

# Legacy (Single environment)
make tf-init           # Initialize Terraform
make tf-plan           # Plan changes
make tf-apply          # Apply changes
make tf-destroy        # Destroy infrastructure
```

### Application

```bash
make install           # Install dependencies
make docker-build      # Build Docker images
make docker-push       # Push to registry
make k8s-deploy        # Deploy to Kubernetes
make k8s-status        # Check deployment status
```

### Monitoring

```bash
make grafana-url       # Get Grafana dashboard URL
make get-urls          # Get application URLs
make monitoring-status # Check monitoring stack
```

### Kubernetes

```bash
make k8s-logs-backend  # View backend logs
make k8s-logs-frontend # View frontend logs
make k8s-delete        # Delete all K8s resources
```

### Utilities

```bash
make check-deps        # Verify required tools
make clean             # Clean build artifacts
```

---

## ⚙️ Configuration

### Environment Variables

**Backend** (`app/backend/.env`):
```env
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/db
TOKEN_SECRET_KEY=your-secret-key-here
FRONTEND_URL=http://your-frontend-url
PORT=5000
```

**Frontend** (`app/frontend/.env`):
```env
REACT_APP_CLOUD_NAME_CLOUDINARY=your-cloudinary-name
REACT_APP_API_URL=http://your-backend-url:5000
```

### Kubernetes Secrets

Update `k8s/secret.yaml` with your values:
```yaml
stringData:
  MONGODB_URI: "your-mongodb-uri"
  TOKEN_SECRET_KEY: "your-secret-key"
```

### Terraform Variables

**Workspace-based** (`infra/workspaces/terraform.tfvars`):
```hcl
region   = "us-east-1"
ami_id   = "ami-0c55b159cbfafe1f0"
key_name = "your-key-pair"
```

**Environment-specific** (in `main.tf` locals):
```hcl
dev = {
  instance_type = "t3.small"
  eks_node_count = 1
}
```

---

## 🔐 Security

### Best Practices Implemented

✅ **Secrets Management**
- Kubernetes secrets for sensitive data
- AWS Secrets Manager integration ready
- No hardcoded credentials in code

✅ **Network Security**
- Private subnets for EKS nodes
- Security groups with minimal access
- Network policies (optional)

✅ **Container Security**
- Trivy vulnerability scanning
- Non-root containers
- Read-only root filesystem (where possible)

✅ **Access Control**
- IAM roles with least privilege
- RBAC for Kubernetes
- MFA recommended for AWS console

✅ **Monitoring & Auditing**
- CloudWatch logs
- Kubernetes audit logs
- Prometheus metrics
---

## 💰 Cost Estimation

### AWS Costs (Monthly)

| Component | Dev | Stage | Prod |
|-----------|-----|-------|------|
| EKS Cluster | $73 | $73 | $73 |
| EC2 Nodes | $15 | $60 | $180 |
| Jenkins EC2 | $15 | $30 | $30 |
| Load Balancers | $20 | $20 | $40 |
| ECR Storage | $1 | $2 | $5 |
| S3 Storage | $1 | $2 | $5 |
| **Total** | **~$125** | **~$187** | **~$333** |

### Azure Costs (Monthly)

| Component | Dev | Stage | Prod |
|-----------|-----|-------|------|
| AKS Cluster | Free | Free | Free |
| VM Nodes | $30 | $60 | $120 |
| Jenkins VM | $30 | $30 | $30 |
| Load Balancers | $20 | $20 | $40 |
| ACR Storage | $5 | $5 | $10 |
| **Total** | **~$85** | **~$115** | **~$200** |

### Cost Optimization Tips

- 💡 Use Spot Instances for dev/stage (50-70% savings)
- 💡 Enable cluster autoscaler
- 💡 Right-size instances based on metrics
- 💡 Use Reserved Instances for prod (up to 75% savings)
- 💡 Delete unused resources regularly
- 💡 Use S3 lifecycle policies

---

## 🐛 Troubleshooting

### Common Issues

#### 1. Pods Not Starting

```bash
# Check pod status
kubectl get pods -n shop

# Describe pod for details
kubectl describe pod <pod-name> -n shop

# Check logs
kubectl logs <pod-name> -n shop
```

**Common causes:**
- Image pull errors (check ECR permissions)
- Resource limits (check node capacity)
- ConfigMap/Secret missing

#### 2. Image Pull Errors

```bash
# Check events
kubectl get events -n shop --sort-by='.lastTimestamp'

# Verify ECR login
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
```

#### 3. EKS Connection Issues

```bash
# Update kubeconfig
aws eks update-kubeconfig --name shop-eks-dev --region us-east-1

# Verify connection
kubectl get nodes

# Check AWS credentials
aws sts get-caller-identity
```

#### 4. Terraform State Lock

```bash
# List locks
aws dynamodb scan --table-name terraform-lock-table

# Force unlock (use carefully!)
terraform force-unlock <lock-id>
```

#### 5. Jenkins Build Failures

```bash
# Check Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log

# Verify Docker permissions
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# Test kubectl access
sudo su - jenkins
kubectl get nodes
```

### Debug Commands

```bash
# Check all resources
kubectl get all -n shop

# View recent events
kubectl get events -n shop --sort-by='.lastTimestamp' | tail -20

# Check node resources
kubectl top nodes

# Check pod resources
kubectl top pods -n shop

# Describe deployment
kubectl describe deployment backend -n shop

# Check service endpoints
kubectl get endpoints -n shop
```

### Getting Help

1. 📖 Check [DEPLOYMENT_GUIDE.txt](DEPLOYMENT_GUIDE.txt)
2. 🔍 Search existing [GitHub Issues](https://github.com/elonerajeev/Multi-Cloud-DevOps-Deployment-Platform/issues)
3. 💬 Open a new issue with:
   - Error messages
   - Steps to reproduce
   - Environment details
   - Relevant logs

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest new features
- 📝 Improve documentation
- 🔧 Submit pull requests
- ⭐ Star the repository

### Development Workflow

1. **Fork the repository**
   ```bash
   # Click "Fork" on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR-USERNAME/Multi-Cloud-DevOps-Deployment-Platform.git
   cd Multi-Cloud-DevOps-Deployment-Platform
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

4. **Make your changes**
   - Write clean, documented code
   - Follow existing code style
   - Add tests if applicable

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add amazing feature"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```

7. **Open a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Describe your changes

---

## 📄 License

This project is licensed under the **ISC License**.

```
Copyright (c) 2024 Rajeev Kumar

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.
```

---

## 👤 Author

**Rajeev Kumar**

- 🌐 GitHub: [@elonerajeev](https://github.com/elonerajeev)
- 📧 Email: [Contact via GitHub](https://github.com/elonerajeev)
- 💼 LinkedIn: [Connect on LinkedIn](https://linkedin.com/in/elonerajeev)

---

## 🙏 Acknowledgments

- AWS for EKS and comprehensive cloud services
- Microsoft Azure for AKS
- HashiCorp for Terraform
- Kubernetes community
- Jenkins community
- Prometheus & Grafana teams
- All open-source contributors

---

## 📚 Additional Resources

### Documentation
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Azure AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)

### Guides in This Repository
- [DEPLOYMENT_GUIDE.txt](DEPLOYMENT_GUIDE.txt) - AWS deployment walkthrough
- [AZURE_DEPLOYMENT_GUIDE.md](AZURE_DEPLOYMENT_GUIDE.md) - Azure deployment guide
- [infra/workspaces/README.md](infra/workspaces/README.md) - Multi-environment setup
- [monitoring/README.md](monitoring/README.md) - Monitoring configuration
---

## ⭐ Star History

If you find this project useful, please consider giving it a star! ⭐

[![Star History Chart](https://api.star-history.com/svg?repos=elonerajeev/Multi-Cloud-DevOps-Deployment-Platform&type=Date)](https://star-history.com/#elonerajeev/Multi-Cloud-DevOps-Deployment-Platform&Date)

---

## 📞 Support

Need help? Here's how to get support:

1. **Documentation**: Check the guides in this repository
2. **Issues**: [Open an issue](https://github.com/elonerajeev/Multi-Cloud-DevOps-Deployment-Platform/issues)
3. **Discussions**: [GitHub Discussions](https://github.com/elonerajeev/Multi-Cloud-DevOps-Deployment-Platform/discussions)

---

<div align="center">

**Made with ❤️ by [Rajeev Kumar](https://github.com/elonerajeev)**

⭐ **Star this repo if you find it helpful!** ⭐

[Report Bug](https://github.com/elonerajeev/Multi-Cloud-DevOps-Deployment-Platform/issues) · [Request Feature](https://github.com/elonerajeev/Multi-Cloud-DevOps-Deployment-Platform/issues) · [Documentation](DEPLOYMENT_GUIDE.txt)

</div>
