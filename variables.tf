variable "AWS_REGION" {
  type        = string
  description = "AWS main region"
  default     = "sa-east-1"
}

variable "AWS_AZ_COUNT" {
  type        = number
  description = "Count of zones to be available"
  default     = 2
}

variable "AWS_AZ_NAMES" {
  type        = list(string)
  description = "Name of zones to be available"
  default     = ["sa-east-1a", "sa-east-1c"]
}

variable "AWS_AMI" {
  type        = string
  description = "AWS image AMI optimized for ECS"
  default     = "ami-0d6ac368fff49ff2d"
}

variable "AWS_ACCESS_KEY" {
  type        = string
  description = "AWS access key"
}

variable "AWS_SECRET_KEY" {
  type        = string
  description = "AWS secret key"
}

variable "AWS_PRIVATE_KEY" {
  type        = string
  description = "AWS private key"
  default     = "key_aws"
}

variable "AWS_PUBLIC_KEY" {
  type        = string
  description = "AWS public key"
  default     = "key_aws.pub"
}

variable "app_config" {
  type = object({
    APP_VERSION   = string
    APP_DOMAIN    = string
    APP_SUBDOMAIN = string
    NODE_ENV      = string
  })
}

variable "cluster_name" {
  type        = string
  description = "ECS cluster name"
  default     = "app-cluster"
}
