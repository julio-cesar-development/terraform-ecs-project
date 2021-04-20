output "eip" {
  value = aws_eip.nat_eip
}

output "lb_dns_name" {
  value = aws_lb.application-lb.dns_name
}

output "ecs_service" {
  value = aws_ecs_service.service
}
