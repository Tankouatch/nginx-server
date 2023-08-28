provider "aws" {
  region = "us-east-1"  # Set your desired AWS region
}

data "aws_ami" "latest_ubuntu_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"]  # Canonical AWS account ID
}

resource "aws_instance" "example_instance" {
  ami           = data.aws_ami.latest_ubuntu_ami.id
  instance_type = "t2.micro"  # Set your desired instance type
}


