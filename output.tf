output "ec2_instance_public_ip" {
  description = "Public IP addresses of EC2 instance"
  value       = aws_instance.ec2-instance.public_ip
}

output "lb_dns_name" {
  value = aws_lb.blackdevs-alb.dns_name
}
