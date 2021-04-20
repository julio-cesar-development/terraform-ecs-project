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

variable "aws_azs" {
  type        = list(string)
  description = "AZs to be available"
  default     = ["a", "b", "c"]
}

variable "root_domain" {
  type        = string
  description = "The root domain on AWS"
}

variable "certificate_arn" {
  type        = string
  description = "The certificate ARN on AWS"
}

variable "ecs_execution_role_arn" {
  type        = string
  description = "AWS ARN of ECS execution role"
}

variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name"
  default     = "application-cluster"
}

variable "ecs_application_image_repository" {
  type        = string
  description = "ECS application image repository"
  default     = "juliocesarmidia/todo-vue"
}

variable "ecs_application_image_tag" {
  type        = string
  description = "ECS application image tag"
  default     = "latest"
}

variable "ecs_application_name" {
  type        = string
  description = "ECS application name"
  default     = "todovue"
}

variable "env" {
  type        = string
  description = "Environment for deploy"
  default     = "development"
}
