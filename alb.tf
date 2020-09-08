resource "aws_lb" "blackdevs-alb" {
  load_balancer_type         = "application"
  name                       = "blackdevs-alb"
  internal                   = false
  enable_deletion_protection = false
  idle_timeout               = 300

  subnets         = aws_subnet.main-subnets.*.id
  security_groups = [aws_security_group.alb-sg.id]

  # TODO: enable access logs
  # access_logs {
  #  bucket  = aws_s3_bucket.access_logs.bucket
  #  prefix  = "production"
  #  enabled = true
  # }

  tags = {
    Name = "blackdevs-alb"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "blackdevs-alb-tg" {
  name                          = "blackdevs-alb-tg"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = aws_vpc.main-vpc.id
  load_balancing_algorithm_type = "least_outstanding_requests"

  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    port                = 80
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "blackdevs_alb_listener_http" {
  load_balancer_arn = aws_lb.blackdevs-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "blackdevs_alb_listener_https" {
  load_balancer_arn = aws_lb.blackdevs-alb.arn
  port              = 443
  protocol          = "HTTPS"

  # ARN for SSL certificate
  certificate_arn = var.aws_certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.blackdevs-alb-tg.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "blackdevs_alb_listener_rule" {
  listener_arn = aws_alb_listener.blackdevs_alb_listener_https.arn
  priority     = 10
  depends_on   = [aws_alb_target_group.blackdevs-alb-tg]

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.blackdevs-alb-tg.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
