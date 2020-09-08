resource "aws_appautoscaling_target" "ecs-target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster.name}/${aws_ecs_service.client-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  min_capacity = 1
  max_capacity = 3

  depends_on = [aws_ecs_cluster.ecs-cluster, aws_ecs_service.client-service, aws_alb_target_group.blackdevs-alb-tg]
}

resource "aws_appautoscaling_policy" "ecs-policy-scale-up" {
  name               = "scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs-target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.ecs-target]
}

resource "aws_appautoscaling_policy" "ecs-policy-scale-down" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs-target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.ecs-target]
}
