#!/bin/bash

set -e

if [ "$TRAVIS_BRANCH" = 'master' ]; then
  export WORKSPACE='production'
else
  export WORKSPACE='development'
fi

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?'[ERROR] Variable AWS_ACCESS_KEY_ID missing'}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?'[ERROR] Variable AWS_SECRET_ACCESS_KEY missing'}
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:?'[ERROR] Variable AWS_DEFAULT_REGION missing'}

docker container run \
  --name awscli \
  --rm -i \
  -v "$PWD/:/data" \
  -w /data \
  --env AWS_ACCESS_KEY_ID \
  --env AWS_SECRET_ACCESS_KEY \
  --env AWS_DEFAULT_REGION \
  --env WORKSPACE \
  --entrypoint "" \
  amazon/aws-cli:2.0.20 sh -c \
  "aws s3 cp s3://blackdevs-aws/terraform/ecs-project/${WORKSPACE}.tfvars ./${WORKSPACE}.tfvars"

(
cat <<EOF
#!/bin/sh

terraform init -backend=true
terraform workspace new "${WORKSPACE}" 2> /dev/null \
  || terraform workspace select "${WORKSPACE}"
terraform workspace show

terraform validate

terraform plan -var-file="${WORKSPACE}.tfvars" -detailed-exitcode -input=false

terraform apply -var-file="${WORKSPACE}.tfvars" -auto-approve
EOF
) | docker container run --rm -i \
  --name terraform \
  -v "$PWD:/data" \
  -w /data \
  --env AWS_ACCESS_KEY_ID \
  --env AWS_SECRET_ACCESS_KEY \
  --env AWS_DEFAULT_REGION \
  --env WORKSPACE \
  --entrypoint "" \
  hashicorp/terraform:0.12.26 sh -c "cat - 1>> run.sh && chmod +x run.sh && sh run.sh"
