#!/bin/bash

set -e

docker container run \
  --name awscli \
  --rm -i \
  -v "$PWD/:/data" \
  -w /data \
  --env AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
  --env AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
  --env AWS_DEFAULT_REGION="$AWS_DEFAULT_REGION" \
  --entrypoint "" \
  amazon/aws-cli:2.0.20 sh -c \
  "aws s3 cp s3://blackdevs-aws/terraform/ecs-project/terraform.tfvars ./terraform.tfvars"

docker container run \
  --name terraform \
  --rm -it \
  -v "$PWD:/data" \
  -w /data \
  --env AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
  --env AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
  --env AWS_DEFAULT_REGION="$AWS_DEFAULT_REGION" \
  --entrypoint "" \
  hashicorp/terraform:0.12.24 sh -c \
  "terraform init -backend=true && \
  terraform validate && \
  terraform plan && \
  terraform apply -auto-approve"
