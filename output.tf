# output "ec2_instance_public_ip" {
#   description = "Public IP addresses of EC2 instance"
#   value       = aws_instance.ec2-instance.public_ip
# }

# output "autoscaling_group" {
#   description = "Autoscaling group"
#   value       = aws_autoscaling_group.instance-asg
# }

# output "launch_configuration" {
#   description = "Launch configuration"
#   value       = aws_launch_configuration.instance-launch-configuration
# }

output "lb_dns_name" {
  value = aws_lb.blackdevs-alb.dns_name
}

# output "dns_namespace" {
#   value = aws_service_discovery_private_dns_namespace.private-dns-namespace
# }

# output "service_discovery" {
#   value = aws_service_discovery_service.client-service-discovery
# }

output "ecs_service" {
  value = aws_ecs_service.client-service
}
