# Terraform Project to provide infrastructure at AWS using ECS

[![Build Status](https://travis-ci.com/juliocesarscheidt/terraform-ecs-project.svg)](https://travis-ci.com/juliocesarscheidt/terraform-ecs-project)
[![GitHub Status](https://badgen.net/github/status/juliocesarscheidt/terraform-ecs-project)](https://github.com/juliocesarscheidt/terraform-ecs-project)
![License](https://badgen.net/badge/license/MIT/blue)

> This is a project of Infrastructure as Code to provide an ECS service running on AWS
> It will provide fargate instances running as ECS services, with autoscaling and service discovery

## Instructions

```bash
# run deploy script
chmod +x deploy.sh && \
  bash deploy.sh
```

## Docs

[https://aws.amazon.com/pt/premiumsupport/knowledge-center/launch-ecs-optimized-ami/](https://aws.amazon.com/pt/premiumsupport/knowledge-center/launch-ecs-optimized-ami/)<br>
[https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html)<br>
[https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-discovery.html](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-discovery.html)<br>
[https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace#hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace#hosted_zone)
[https://medium.com/@bradford_hamilton/deploying-containers-on-amazons-ecs-using-fargate-and-terraform-part-2-2e6f6a3a957f](https://medium.com/@bradford_hamilton/deploying-containers-on-amazons-ecs-using-fargate-and-terraform-part-2-2e6f6a3a957f)
