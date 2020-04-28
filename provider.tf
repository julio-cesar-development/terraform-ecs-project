terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}
