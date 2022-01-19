locals {
  enabled                           = module.this.enabled
  zone_name                         = var.zone_name == "" ? "${var.domain_name}." : var.zone_name
  process_domain_validation_options = local.enabled && var.process_domain_validation_options && var.validation_method == "DNS"
  domain_validation_options_set     = local.process_domain_validation_options ? aws_acm_certificate.brickscourt.domain_validation_options : toset([])
}


resource "aws_acm_certificate" "brickscourt" {
  domain_name       = var.domain_name
  validation_method = var.validation_method

  tags = module.this.tags

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "brickscourt" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "brickscourt" {
  for_each = {
    for dvo in aws_acm_certificate.brickscourt.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.cert_ttl
  type            = each.value.type
  zone_id         = data.aws_route53_zone.brickscourt.zone_id
}

resource "aws_acm_certificate_validation" "brickscourt" {
  certificate_arn         = var.cert_arn
  validation_record_fqdns = [for record in aws_route53_record.brickscourt : record.fqdn]
}
