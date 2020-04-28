resource "aws_lb" "blackdevs-alb" {
  load_balancer_type         = "application"
  name                       = "blackdevs-alb"
  internal                   = false
  enable_deletion_protection = true
  idle_timeout               = 300

  subnets         = [aws_subnet.default-public.id]
  security_groups = [aws_security_group.alb_sg.id]

  # access_logs {
  #  bucket  = aws_s3_bucket.access_logs.bucket
  #  prefix  = "production"
  #  enabled = true
  # }

  tags = {
    Name = "blackdevs-alb"
  }
}

resource "aws_lb_listener" "blackdevs_alb_listener" {
  load_balancer_arn = aws_lb.blackdevs-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.blackdevs-alb-tg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "blackdevs-alb-tg" {
  name     = "blackdevs-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main-vpc.id

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_lb_listener_rule" "blackdevs_alb_listener_rule" {
  listener_arn = aws_lb_listener.blackdevs_alb_listener.arn
  priority     = 10
  depends_on   = [aws_lb_target_group.blackdevs-alb-tg]

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blackdevs-alb-tg.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  # condition {
  #  host_header {
  #   values = ["example.com"]
  #  }
  # }
}
