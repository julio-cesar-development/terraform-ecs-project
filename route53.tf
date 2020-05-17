resource "aws_route53_zone" "app_zone" {
  name = "${var.app_config.APP_SUBDOMAIN}.${var.app_config.APP_DOMAIN}."
}

# create a NS record in the root zone
resource "aws_route53_record" "app_record_root_zone" {
  allow_overwrite = false
  name            = "${var.app_config.APP_SUBDOMAIN}.${var.app_config.APP_DOMAIN}"
  ttl             = 30
  type            = "NS"
  zone_id         = var.AWS_ROOT_ZONE_ID

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
  name            = "${var.app_config.APP_SUBDOMAIN}.${var.app_config.APP_DOMAIN}."
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
  name    = "${var.app_config.APP_SUBDOMAIN}.${var.app_config.APP_DOMAIN}."
  type    = "A"

  alias {
    name                   = aws_lb.blackdevs-alb.dns_name
    zone_id                = aws_lb.blackdevs-alb.zone_id
    evaluate_target_health = false
  }
}
