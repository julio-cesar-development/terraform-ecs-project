#!/bin/sh

terraform init -backend=true
terraform workspace new "production" 2> /dev/null   || terraform workspace select "production"
terraform workspace show

terraform validate
