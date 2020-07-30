data "template_file" "user-data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    ecs_cluster_name = var.ecs_cluster_name
  }
}

resource "aws_instance" "ec2-instance" {
  ami = var.aws_ami
  # special profile to execute EC2 and ECS
  iam_instance_profile = var.aws_iam_instance_profile
  instance_type        = var.aws_instance_size
  user_data            = data.template_file.user-data.rendered
  key_name             = var.aws_key_name

  subnet_id              = aws_subnet.subnet-main[0].id
  vpc_security_group_ids = [aws_security_group.application-sg.id]

  tags = {
    Name = "ec2-instance"
  }
}
