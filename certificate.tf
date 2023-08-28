provider "aws" {
  region = "us-east-1"  # Set your desired AWS region
}

resource "aws_acm_certificate" "example_certificate" {
  domain_name       = "example.com"  # Replace with your domain name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "example_zone" {
  name = "example.com"  # Replace with your domain name
}

resource "aws_route53_record" "example_acm_validation" {
  name    = aws_acm_certificate.example_certificate.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.example_certificate.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.example_zone.zone_id
  records = [aws_acm_certificate.example_certificate.domain_validation_options.0.resource_record_value]
  ttl     = 60
}
