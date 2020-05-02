output "ec2_instance_public_ip" {
  description = "Public IP addresses of EC2 instance"
  value       = aws_instance.main-ec2-instance.public_ip
}

output "ec2_instance_id" {
  description = "ID of EC2 instance"
  value       = aws_instance.main-ec2-instance.id
}

output "lb_dns_name" {
  value = "${aws_lb.blackdevs-alb.dns_name}"
}
