# AWS variables
variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "sa-east-1"
}

variable "aws_az_count" {
  type        = number
  description = "AWS availability zones count"
  default     = 2
}

variable "aws_az_names" {
  type        = list(string)
  description = "Name of zones to be available"
  default     = ["sa-east-1a", "sa-east-1c"]
}

variable "aws_public_cidr" {
  type        = string
  description = "AWS public subnet CIDR block"
  default     = "10.0.0.0/16"
}

variable "aws_ami" {
  type        = string
  description = "AWS image AMI optimized for ECS"
  default     = ""
}

variable "aws_instance_size" {
  type        = string
  description = "AWS instance size for EC2"
  default     = "t2.micro"
}

variable "aws_hosted_zone_id" {
  type        = string
  description = "AWS hosted zone ID"
}

variable "aws_certificate_arn" {
  type        = string
  description = "AWS certificate ARN"
}

variable "aws_key_name" {
  type        = string
  description = "AWS SSH key name"
}

variable "aws_iam_instance_profile" {
  type        = string
  description = "AWS profile to execute EC2"
}

variable "aws_arn_ecs_execution_role" {
  type        = string
  description = "AWS ARN of ECS execution role"
}

variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name"
  default     = "app-cluster"
}

variable "app_config" {
  type = object({
    app_version = string
    app_domain  = string
    node_env    = string
  })
}
