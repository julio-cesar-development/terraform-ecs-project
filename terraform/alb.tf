resource "aws_lb" "application-lb" {
  load_balancer_type         = "application"
  name                       = "application-lb"
  internal                   = false
  enable_deletion_protection = false
  idle_timeout               = 300

  subnets         = aws_subnet.public_subnet.*.id
  security_groups = [aws_security_group.lb-sg.id]

  # TODO: enable access logs
  # access_logs {
  #  bucket  = aws_s3_bucket.access_logs.bucket
  #  prefix  = "production"
  #  enabled = true
  # }

  tags = {
    Name = "application-lb"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "application-lb-tg" {
  name                          = "application-lb-tg"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = aws_vpc.vpc_0.id
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

resource "aws_alb_listener" "lb-listener-http" {
  load_balancer_arn = aws_lb.application-lb.arn
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

resource "aws_alb_listener" "lb-listener-https" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = 443
  protocol          = "HTTPS"

  # ARN for SSL certificate
  certificate_arn = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.application-lb-tg.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "lb-listener-rule" {
  listener_arn = aws_alb_listener.lb-listener-https.arn
  priority     = 100
  depends_on   = [aws_alb_target_group.application-lb-tg]

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.application-lb-tg.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
