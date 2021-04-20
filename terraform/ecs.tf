resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.ecs_cluster_name}-${var.env}"
}

data "template_file" "definition-template" {
  template = file("${path.module}/templates/definition.json")

  vars = {
    NODE_ENV                     = var.env
    APPLICATION_IMAGE_REPOSITORY = var.ecs_application_image_repository
    APPLICATION_IMAGE_TAG        = var.ecs_application_image_tag
    APPLICATION_NAME             = var.ecs_application_name
  }
}

resource "aws_ecs_task_definition" "task-definition" {
  family = "task-definition"
  # special role to execute ECS
  execution_role_arn    = var.ecs_execution_role_arn
  container_definitions = data.template_file.definition-template.rendered
  network_mode          = "awsvpc"

  cpu    = 512
  memory = 1024

  requires_compatibilities = ["FARGATE"]

  depends_on = [aws_ecs_cluster.ecs-cluster]
}

resource "aws_ecs_service" "service" {
  name                = "service"
  cluster             = aws_ecs_cluster.ecs-cluster.name
  task_definition     = aws_ecs_task_definition.task-definition.arn
  scheduling_strategy = "REPLICA"

  desired_count                      = 2
  deployment_minimum_healthy_percent = 80
  deployment_maximum_percent         = 200

  launch_type = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.private_subnet.*.id
    security_groups  = [aws_security_group.application-sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.application-lb-tg.id
    container_name   = var.ecs_application_name
    container_port   = 80
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.service-discovery.arn
    container_name = var.ecs_application_name
  }

  depends_on = [aws_ecs_cluster.ecs-cluster]
}

resource "aws_service_discovery_private_dns_namespace" "private-dns-namespace" {
  name        = "${var.ecs_cluster_name}-${var.env}.local"
  description = "ECS Namespace for Service Discovery"
  vpc         = aws_vpc.vpc_0.id

  tags = {
    Name = "${var.ecs_cluster_name}-${var.env}.local"
  }

  depends_on = [aws_ecs_cluster.ecs-cluster]
}

resource "aws_service_discovery_service" "service-discovery" {
  name = "service-discovery"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private-dns-namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = {
    Name = "service-discovery"
  }

  depends_on = [aws_ecs_cluster.ecs-cluster]
}
