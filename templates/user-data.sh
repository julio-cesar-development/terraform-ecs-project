#!/bin/bash

echo "ECS_CLUSTER=${ecs_cluster_name}" >> /etc/ecs/ecs.config
echo "NO_PROXY=169.254.169.254,169.254.170.2,/var/run/docker.sock" >> /etc/ecs/ecs.config

# sudo /usr/libexec/amazon-ecs-init start

# tail -f /var/log/ecs/ecs-agent.log
# tail -f /var/log/ecs/ecs-init.log
