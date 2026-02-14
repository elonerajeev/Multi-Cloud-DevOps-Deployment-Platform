variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = "shop-ec2-role"
}

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
  default     = "shop-ec2-policy"
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
  default     = "prod"
}
