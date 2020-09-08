# data "aws_ami" "ecs-ami" {
#   most_recent = true
#   filter {
#     name = "name"
#     values = ["amzn2-ami-ecs-hvm-2.0.*"]
#   }
#   filter {
#     name = "architecture"
#     values = ["x86_64"]
#   }
#   owners = ["amazon"]
# }

# resource "aws_launch_configuration" "instance-launch-configuration" {
#   name_prefix = "ec2-instance"

#   image_id                    = var.aws_ami == "" ? data.aws_ami.ecs-ami.id : var.aws_ami
#   instance_type               = var.aws_instance_size
#   iam_instance_profile        = var.aws_iam_instance_profile
#   security_groups             = [aws_security_group.application-sg.id]
#   key_name                    = var.aws_key_name

#   associate_public_ip_address = true

#   user_data = data.template_file.user-data.rendered

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_autoscaling_group" "instance-asg" {
#   name = "instance-asg"

#   launch_configuration = aws_launch_configuration.instance-launch-configuration.name
#   desired_capacity     = 1
#   min_size             = 1
#   max_size             = 3

#   vpc_zone_identifier = aws_subnet.main-subnets.*.id

#   # health_check_type = "EC2"
#   # health_check_grace_period = 300

#   # health_check_type         = "ELB"
#   # health_check_grace_period = 300

#   force_delete              = true

#   # load_balancers            = [aws_lb.blackdevs-alb.name]
#   # target_group_arns = [aws_alb_target_group.blackdevs-alb-tg.arn]

#   lifecycle {
#     create_before_destroy = true
#     ignore_changes = [load_balancers, target_group_arns]
#   }

#   depends_on = [aws_lb.blackdevs-alb]
# }
