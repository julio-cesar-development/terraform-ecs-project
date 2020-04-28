variable "AWS_REGION" {
  type        = string
  description = "AWS region"
  default     = "sa-east-1"
}

variable "AWS_ACCESS_KEY" {
  type        = string
  description = "AWS access key"
}

variable "AWS_SECRET_KEY" {
  type        = string
  description = "AWS secret key"
}

variable "app_config" {
  type = object({
    APP_VERSION   = string
    APP_DOMAIN    = string
    APP_SUBDOMAIN = string
    NODE_ENV      = string
  })
}
