variable "project_name" {
  description = "Project name prefix for ECR repositories"
  type        = string
  default     = "shop-app"
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
  default     = "prod"
}
