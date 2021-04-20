# ECS Infrastructure on AWS

[![Build Status](https://travis-ci.com/juliocesarscheidt/terraform-ecs-project.svg)](https://travis-ci.com/juliocesarscheidt/terraform-ecs-project)
[![GitHub Status](https://badgen.net/github/status/juliocesarscheidt/terraform-ecs-project)](https://github.com/juliocesarscheidt/terraform-ecs-project)
![License](https://badgen.net/badge/license/MIT/blue)

> This is a project of Infrastructure as Code to provide an ECS service running on AWS.
> It will deploy fargate instances running ECS services, with auto scaling and service discovery inside a private subnet, with a load balancer in a public subnet to receive traffic from internet.

## Architecture

![Architecture](./images/architecture.svg)

## Instructions

```bash
# run deploy script
chmod +x deploy.sh && \
  bash deploy.sh
```
