resource "aws_key_pair" "nginx_keypair" {
  key_name   = "nginx"
  public_key = file("./nginx.pem")  # Path to your public key file
}

output "nginx_private_key" {
  value = aws_key_pair.nginx_keypair.private_key
}