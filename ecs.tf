resource "aws_ecs_cluster" "app-cluster" {
  name = var.ecs_cluster_name
}

data "template_file" "ecs-definition-template" {
  template = file("${path.module}/templates/definition.json")
  vars = {
    NODE_ENV    = var.app_config.node_env
    APP_VERSION = var.app_config.app_version
  }
}

resource "aws_ecs_task_definition" "app-definition" {
  family = "app-definition"
  # special role to execute ECS
  execution_role_arn    = var.aws_arn_ecs_execution_role
  container_definitions = data.template_file.ecs-definition-template.rendered
}

resource "aws_ecs_service" "blackdevs_app_service" {
  name                = "blackdevs_app_service"
  cluster             = aws_ecs_cluster.app-cluster.name
  task_definition     = aws_ecs_task_definition.app-definition.arn
  scheduling_strategy = "DAEMON"
  desired_count       = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.blackdevs-alb-tg.id
    container_name   = "todo-vue"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.blackdevs_alb_listener_http]

  # lifecycle {
  #   prevent_destroy = true
  # }
}
