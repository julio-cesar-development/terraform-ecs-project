resource "aws_lb" "blackdevs-alb" {
  load_balancer_type         = "application"
  name                       = "blackdevs-alb"
  internal                   = false
  enable_deletion_protection = false
  idle_timeout               = 300

  subnets = aws_subnet.subnet-main.*.id
  security_groups = [aws_security_group.alb-sg.id]

  # access_logs {
  #  bucket  = aws_s3_bucket.access_logs.bucket
  #  prefix  = "production"
  #  enabled = true
  # }

  tags = {
    Name = "blackdevs-alb"
  }
}

resource "aws_lb_target_group" "blackdevs-alb-tg" {
  name     = "blackdevs-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main-vpc.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    port                = 80
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
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
}

resource "aws_alb_target_group_attachment" "instance_attachment" {
  target_group_arn = aws_lb_target_group.blackdevs-alb-tg.arn
  target_id        = aws_instance.main-ec2-instance.id
  port             = 80
}
