resource "aws_route53_zone" "app_zone" {
  name = "todoapp.onaws.${var.app_config.app_domain}"
}

# create a NS record in the root zone
resource "aws_route53_record" "app_zone_record" {
  allow_overwrite = false
  name            = "todoapp.onaws.${var.app_config.app_domain}"
  ttl             = 30
  type            = "NS"
  zone_id         = var.aws_hosted_zone_id

  records = [
    aws_route53_zone.app_zone.name_servers.0,
    aws_route53_zone.app_zone.name_servers.1,
    aws_route53_zone.app_zone.name_servers.2,
    aws_route53_zone.app_zone.name_servers.3,
  ]
}

# create a NS record in the app zone
resource "aws_route53_record" "app_record_app_zone" {
  allow_overwrite = true
  name            = "todoapp.onaws.${var.app_config.app_domain}"
  ttl             = 30
  type            = "NS"
  zone_id         = aws_route53_zone.app_zone.zone_id

  records = [
    aws_route53_zone.app_zone.name_servers.0,
    aws_route53_zone.app_zone.name_servers.1,
    aws_route53_zone.app_zone.name_servers.2,
    aws_route53_zone.app_zone.name_servers.3,
  ]
}

# create a record as alias pointing to load balancer
resource "aws_route53_record" "main_lb_dns_record" {
  zone_id = aws_route53_zone.app_zone.zone_id
  name    = "todoapp.onaws.${var.app_config.app_domain}"
  type    = "A"

  alias {
    name                   = aws_lb.blackdevs-alb.dns_name
    zone_id                = aws_lb.blackdevs-alb.zone_id
    evaluate_target_health = false
  }
}
