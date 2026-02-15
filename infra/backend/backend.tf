terraform {
  backend "s3" {
    bucket         = "rajeev-terraform-state-1771131682-396ee83a"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

