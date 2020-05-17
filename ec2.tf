data "template_file" "user-data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    ecs_cluster_name = var.cluster_name
  }
}

resource "aws_key_pair" "aws_keys" {
  key_name   = "aws_keys"
  public_key = file(var.SSH_PUBLIC_KEY)
}

resource "aws_instance" "main-ec2-instance" {
  ami = var.AWS_AMI
  # special profile to execute EC2 and ECS
  iam_instance_profile = "AmazonEC2Role"
  instance_type = "t2.micro"
  user_data     = data.template_file.user-data.rendered
  key_name      = aws_key_pair.aws_keys.key_name

  subnet_id              = aws_subnet.subnet-main[0].id
  vpc_security_group_ids = [aws_security_group.application-sg.id]

  tags = {
    Name = "main-ec2-instance"
  }
}
