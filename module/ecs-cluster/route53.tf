

data "aws_route53_zone" "domain" {
  name         = "${var.domain_name}."
  private_zone = var.private_zone
}

resource "aws_route53_record" "hostname" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = var.host_name != "" ? format("%s.%s", var.host_name, data.aws_route53_zone.domain.name) : format("%s", data.aws_route53_zone.domain.name)
  type    = "A"

  alias {
    name                   = aws_alb.main.dns_name
    zone_id                = aws_alb.main.zone_id
    evaluate_target_health = true
  }
}
