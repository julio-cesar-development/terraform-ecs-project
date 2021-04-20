#!/bin/sh

terraform init -backend=true

terraform workspace new "development" 2> /dev/null   || terraform workspace select "development"

terraform validate

terraform plan -var-file="development.tfvars"   -detailed-exitcode -input=false

# terraform apply -var-file="development.tfvars" #   -auto-approve
