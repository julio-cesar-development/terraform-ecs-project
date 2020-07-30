# Terraform Project to provide infrastructure at AWS using ECS

[![Build Status](https://travis-ci.org/julio-cesar-development/terraform-ecs-project.svg)](https://travis-ci.org/julio-cesar-development/terraform-ecs-project)
[![GitHub Status](https://badgen.net/github/status/julio-cesar-development/terraform-ecs-project)](https://github.com/julio-cesar-development/terraform-ecs-project)
![License](https://badgen.net/badge/license/MIT/blue)

> This is a project of Infrastructure as Code to provide an ECS service running on AWS, with a Load Balancer and HTTPS enabled

## Instructions

```bash
# fill your variables in this command
cat <<EOF | tee terraform.tfvars
aws_access_key      = ""
aws_secret_key      = ""
aws_hosted_zone_id  = ""
aws_certificate_arn = ""
aws_key_name        = ""
aws_iam_instance_profile   = ""
aws_arn_ecs_execution_role = ""
app_config = {
  app_version = ""
  app_domain  = ""
  node_env    = ""
}
EOF

# run deploy script
chmod +x deploy.sh && \
    bash deploy.sh
```

## Docs

[https://aws.amazon.com/pt/premiumsupport/knowledge-center/launch-ecs-optimized-ami/](https://aws.amazon.com/pt/premiumsupport/knowledge-center/launch-ecs-optimized-ami/)<br>
[https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html)<br>
