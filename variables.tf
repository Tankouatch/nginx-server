variable "aws_region" {
  type = string
  default = "us-west-2"   # Replace with your desired AWS region
}

variable "domain_name" {
  type = string
  default = "tchouetckeatankoua.interview.exosite.biz" # Replace with your existing domain name
}

variable "subdomain" {
  type = string
  default = "nginx"    # Replace with the subdomain name you want to create
}

variable "port" {
  type = number
  default = 80
}

variable "keypair" {
  type = string
  default = "nginx"  
}
variable "vpc-id" {
  type = string
  default = "vpc-0c2a36846ba20e729"
}


variable "instance_type" {
  type = string
  default = "t4g.nano"
}

