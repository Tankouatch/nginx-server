# get details about a route 53 hosted zone
data "aws_route53_zone" "route53_zone" {
  name = var.domain_name
  # This can be true or false
  private_zone = false
}

# Use this data source to get the ARN of a certificate in AWS Certificate Manager (ACM)
data "aws_acm_certificate" "example_certificate" {
  domain       = var.domain_name 
  most_recent  = true
}

data "local_file" "public1" {
  filename = "./public1"
}

data "local_file" "public2" {
  filename = "./public2"
}

data "local_file" "private1" {
  filename = "./private1"
}








