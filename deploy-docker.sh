#!/bin/bash

set -e

docker container run \
  --name terraform \
  --rm -it \
  -v "$PWD:/data" \
  -w /data \
  --entrypoint "" \
  hashicorp/terraform:0.12.24 sh -c \
  "terraform init -backend=true && \
  terraform validate && \
  terraform plan && \
  terraform apply -auto-approve"
