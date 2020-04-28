resource "aws_ecs_cluster" "app-cluster" {
  name = "app-cluster"
}

# data "template_file" "ecs-definition" {
#   template = "${file("${path.module}/definition.json")}"

#   vars {
#     test = "${test}"
#   }
# }

resource "aws_ecs_task_definition" "app-definition" {
  family                = "app-definition"
  container_definitions = <<DEFINITION
[
  {
    "dnsSearchDomains": null,
    "logConfiguration": null,
    "entryPoint": null,
    "portMappings": [{
      "hostPort": 0,
      "protocol": "tcp",
      "containerPort": 80
    }],
    "command": null,
    "linuxParameters": null,
    "cpu": 0,
    "environment": [{
      "name": "NODE_ENV",
      "value": "${var.app_config.NODE_ENV}"
    }],
    "ulimits": null,
    "repositoryCredentials": null,
    "dnsServers": null,
    "mountPoints": [],
    "workingDirectory": null,
    "dockerSecurityOptions": null,
    "memory": null,
    "memoryReservation": 128,
    "volumesFrom": [],
    "image": "juliocesarmidia/todo-vue:${var.app_config.APP_VERSION}",
    "disableNetworking": null,
    "healthCheck": null,
    "essential": true,
    "links": null,
    "hostname": null,
    "extraHosts": null,
    "user": null,
    "readonlyRootFilesystem": null,
    "dockerLabels": null,
    "privileged": null,
    "name": "server"
  }
]
DEFINITION
}

resource "aws_ecs_service" "blackdevs_app_service" {
  name                = "blackdevs_app_service"
  cluster             = aws_ecs_cluster.app-cluster.name
  task_definition     = aws_ecs_task_definition.app-definition.arn
  scheduling_strategy = "DAEMON"

  load_balancer {
    target_group_arn = aws_lb_target_group.blackdevs-alb-tg.id
    container_name   = "server"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.blackdevs_alb_listener]

  # lifecycle {
  #   prevent_destroy = true
  # }
}
