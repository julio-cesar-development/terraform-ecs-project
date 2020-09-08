resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.ecs_cluster_name
}

data "template_file" "client-definition-template" {
  template = file("${path.module}/templates/definition.json")

  vars = {
    NODE_ENV    = var.app_config.node_env
    APP_VERSION = var.app_config.app_version
  }
}

resource "aws_ecs_task_definition" "client-definition" {
  family = "client-definition"
  # special role to execute ECS
  execution_role_arn    = var.aws_arn_ecs_execution_role
  container_definitions = data.template_file.client-definition-template.rendered
  network_mode          = "awsvpc"

  cpu    = 512
  memory = 1024

  requires_compatibilities = ["FARGATE"]

  # tags = {
  #   Name = "client-definition"
  # }
}

resource "aws_ecs_service" "client-service" {
  name                = "client-service"
  cluster             = aws_ecs_cluster.ecs-cluster.name
  task_definition     = aws_ecs_task_definition.client-definition.arn
  scheduling_strategy = "REPLICA"

  desired_count                      = 2
  deployment_minimum_healthy_percent = 80
  deployment_maximum_percent         = 200

  launch_type = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.main-subnets.*.id
    security_groups  = [aws_security_group.application-sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.blackdevs-alb-tg.id
    container_name   = "todoapp"
    container_port   = 80
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.client-service-discovery.arn
    container_name = "todoapp"
  }

  # tags = {
  #   Name = "client-service"
  # }

  depends_on = [aws_alb_listener.blackdevs_alb_listener_https]
}

resource "aws_service_discovery_private_dns_namespace" "private-dns-namespace" {
  name        = "${var.ecs_cluster_name}.local"
  description = "ECS Namespace for Service Discovery"
  vpc         = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.ecs_cluster_name}.local"
  }
}

resource "aws_service_discovery_service" "client-service-discovery" {
  name = "client-service-discovery"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private-dns-namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = {
    Name = "client-service-discovery"
  }
}
