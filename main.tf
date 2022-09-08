provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "web" {
  instance_type      = "t2.micro"
  ami               = "ami-0cff7528ff583bf9a"
  availability_zone = "us-east-1a"
  key_name = "newkey"
  tags = {
     Name = "terra-ec2"
  }	
}
resource "aws_security_group" "nginx" {
  name        = "nginx"
  description = "Access for Nginx"
  vpc_id      = "vpc-010cd557dc4b8de4d"

  ingress {
    description = "Web Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
 
resource "aws_key_pair" "newkey" {
  key_name   = "newkey"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "newkey" {
    content  = tls_private_key.rsa.private_key_pem
    filename = "newkey"
}
output "ip" {
  value = aws_instance.web.public_ip
}
