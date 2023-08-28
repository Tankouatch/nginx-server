
# Create a record set for the subdomain nginx.
resource "aws_route53_record" "subdomain" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = "${var.subdomain}" 
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.load_balancer.dns_name]
}

# Create Application Load Balancer (ALB)

resource "aws_lb" "load_balancer" {
  name               = "nginx-alb"
  load_balancer_type = "application"
  security_groups    = [
    aws_security_group.lb_sg.id
  ]

  subnets = [
    data.local_file.public1.content,
    data.local_file.public2.content,
  ]

  enable_deletion_protection = false

  tags = {
    Name = "nginx-alb"  # can be customized
  }
}


# Create ALB listener for http request
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn 
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Create ALB listener for https request and terminate the ssl
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.example_certificate.arn

  default_action {
    type            = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  
}

# Create ALB target group
resource "aws_lb_target_group" "nginx" {
  name     = "nginx-target-group"
  port     = var.port
  protocol = "HTTP"
  vpc_id   = var.vpc-id 
}

# Create EC2 instance

resource "aws_instance" "nginx_instance" {
  ami           = data.aws_ami.latest_ubuntu_ami.id
  instance_type = var.instance_type
  subnet_id     = data.local_file.private1.content
  key_name      = var.keypair
  security_groups = [
    aws_security_group.lb_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y 
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable ngnix
              echo "Welcome to Nginx" > /var/www/html/index.html
              EOF

  tags = {
    Name = "nginx-instance"
  }
}

# Create ALB target group attachment
resource "aws_lb_target_group_attachment" "nginx_instance_attachment" {
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx_instance.id
  port             = var.port
}

# Create ALB listener rule
resource "aws_lb_listener_rule" "nginx" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  condition {
    host_header {
      values = ["${var.subdomain}.${var.domain_name}"]
    }
  }
}

