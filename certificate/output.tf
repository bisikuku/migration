output "cert_arn" {
  value = aws_acm_certificate.brickscourt.arn
}

output "lb_cert_arn" {
  value = aws_acm_certificate_validation.brickscourt.certificate_arn
}