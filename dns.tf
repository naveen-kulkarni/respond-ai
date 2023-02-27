resource "aws_route53_zone" "route-53" {
  name = "example.com"
}

resource "aws_route53_record" "record" {
  zone_id = aws_route53_zone.route-53.id
  name    = "example.com"
  type    = "A"

  alias {
    name                   = aws_elb.elb.dns_name
    zone_id                = aws_elb.elb.zone_id
    evaluate_target_health = true
  }
}
