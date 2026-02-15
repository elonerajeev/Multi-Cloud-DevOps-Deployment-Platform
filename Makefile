.PHONY: help install build docker-build docker-push deploy clean test

# Variables
AWS_REGION := us-east-1
AWS_ACCOUNT_ID := 252979663162
ECR_REGISTRY := $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com
CLUSTER_NAME := shop-eks

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ============================================
# LOCAL DEVELOPMENT
# ============================================

install: ## Install all dependencies
	cd app/backend && npm install
	cd app/frontend && npm install

dev-backend: ## Run backend locally
	cd app/backend && npm run dev

dev-frontend: ## Run frontend locally
	cd app/frontend && npm start

test: ## Run tests
	cd app/backend && npm test
	cd app/frontend && npm test

clean: ## Clean node_modules and build artifacts
	rm -rf app/backend/node_modules app/frontend/node_modules
	rm -rf app/frontend/build

# ============================================
# DOCKER
# ============================================

docker-build: ## Build Docker images locally
	docker build -t shop-backend:latest -f app/backend/Dockerfile.prod app/backend
	docker build -t shop-frontend:latest -f app/frontend/Dockerfile.prod app/frontend

docker-run: ## Run Docker containers locally
	docker run -d -p 5000:5000 --name backend shop-backend:latest
	docker run -d -p 3000:3000 --name frontend shop-frontend:latest

docker-stop: ## Stop local Docker containers
	docker stop backend frontend || true
	docker rm backend frontend || true

# ============================================
# AWS ECR
# ============================================

ecr-login: ## Login to AWS ECR
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_REGISTRY)

docker-push: ecr-login ## Push images to ECR
	docker tag shop-backend:latest $(ECR_REGISTRY)/shop-app-backend:latest
	docker tag shop-frontend:latest $(ECR_REGISTRY)/shop-app-frontend:latest
	docker push $(ECR_REGISTRY)/shop-app-backend:latest
	docker push $(ECR_REGISTRY)/shop-app-frontend:latest

# ============================================
# TERRAFORM - Multi-Environment
# ============================================

tf-workspace-init: ## Initialize Terraform workspaces
	cd infra/workspaces && terraform init

tf-workspace-list: ## List all workspaces
	cd infra/workspaces && terraform workspace list

# Deploy to specific environments
deploy-dev: ## Deploy to dev environment
	cd infra/workspaces && ./deploy.sh dev apply

deploy-stage: ## Deploy to staging environment
	cd infra/workspaces && ./deploy.sh stage apply

deploy-prod: ## Deploy to production environment
	cd infra/workspaces && ./deploy.sh prod apply

# Plan changes
plan-dev: ## Plan dev environment changes
	cd infra/workspaces && ./deploy.sh dev plan

plan-stage: ## Plan staging environment changes
	cd infra/workspaces && ./deploy.sh stage plan

plan-prod: ## Plan production environment changes
	cd infra/workspaces && ./deploy.sh prod plan

# Destroy environments
destroy-dev: ## Destroy dev environment
	cd infra/workspaces && ./deploy.sh dev destroy

destroy-stage: ## Destroy staging environment
	cd infra/workspaces && ./deploy.sh stage destroy

destroy-prod: ## Destroy production environment (DANGEROUS!)
	cd infra/workspaces && ./deploy.sh prod destroy

# ============================================
# TERRAFORM (Legacy - Single Environment)
# ============================================

tf-init: ## Initialize Terraform
	cd infra/environments/prod && terraform init

tf-plan: ## Plan Terraform changes
	cd infra/environments/prod && terraform plan

tf-apply: ## Apply Terraform changes
	cd infra/environments/prod && terraform apply

tf-destroy: ## Destroy Terraform infrastructure
	cd infra/environments/prod && terraform destroy

tf-output: ## Show Terraform outputs
	cd infra/environments/prod && terraform output

# ============================================
# KUBERNETES
# ============================================

k8s-config: ## Configure kubectl for EKS
	aws eks update-kubeconfig --name $(CLUSTER_NAME) --region $(AWS_REGION)

k8s-deploy: ## Deploy application to Kubernetes
	kubectl apply -f k8s/namespace.yaml
	kubectl apply -f k8s/configmap.yaml
	kubectl apply -f k8s/secret.yaml
	kubectl apply -f k8s/backend/
	kubectl apply -f k8s/frontend/
	kubectl apply -f k8s/ingress.yaml
	kubectl apply -f k8s/network-policy.yaml

k8s-status: ## Check Kubernetes deployment status
	kubectl get pods -n shop
	kubectl get svc -n shop
	kubectl get ingress -n shop

k8s-logs-backend: ## View backend logs
	kubectl logs -n shop -l app=backend --tail=100 -f

k8s-logs-frontend: ## View frontend logs
	kubectl logs -n shop -l app=frontend --tail=100 -f

k8s-delete: ## Delete Kubernetes resources
	kubectl delete -f k8s/ --recursive

# ============================================
# FULL DEPLOYMENT
# ============================================

setup-backend: ## Setup Terraform backend (S3 + DynamoDB)
	./scripts/setup-terraform-backend.sh

deploy-infra: tf-init tf-apply k8s-config ## Deploy infrastructure

deploy-infra-azure: ## Deploy Azure infrastructure
	cd infra/azure/environments/prod && terraform init && terraform apply

deploy-app: docker-build docker-push k8s-deploy ## Build and deploy application

deploy-all: deploy-infra deploy-app ## Full deployment (infra + app)

# ============================================
# MONITORING
# ============================================

monitoring-status: ## Check monitoring stack
	kubectl get pods -n monitoring
	kubectl get svc -n monitoring

grafana-url: ## Get Grafana URL
	@echo "Grafana URL:"
	@kubectl get svc -n monitoring monitoring-grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

# ============================================
# UTILITIES
# ============================================

check-deps: ## Check if required tools are installed
	@command -v docker >/dev/null 2>&1 || echo "❌ Docker not installed"
	@command -v kubectl >/dev/null 2>&1 || echo "❌ kubectl not installed"
	@command -v terraform >/dev/null 2>&1 || echo "❌ Terraform not installed"
	@command -v aws >/dev/null 2>&1 || echo "❌ AWS CLI not installed"
	@echo "✅ All required tools are installed"

get-urls: ## Get application URLs
	@echo "Backend URL:"
	@kubectl get svc -n shop backend -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
	@echo "\nFrontend URL:"
	@kubectl get svc -n shop frontend -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
