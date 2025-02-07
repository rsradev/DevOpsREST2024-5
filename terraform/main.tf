provider "aws" {
  region = "eu-west-1"
}

data "external" "home" {
  program = ["sh", "-c", "echo '{\"value\":\"'$HOME'\"}'"]
}

resource "aws_key_pair" "ansible_key_pair" {
  key_name   = "ansible_key_pair"
  public_key = tls_private_key.ansible_key.public_key_openssh
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic on port 80"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami             = "ami-0c55b159cbfafe1f0"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ansible_key_pair.key_name
  security_groups = [aws_security_group.allow_http.name]
  user_data       = file("${path.module}/resources/user_script.sh")
  
  
  associate_public_ip_address = true

  tags = {
    Name = "devopsrest2024-5"
    Role = "webserver"
    Public = "true"
  }
}


output "public_ip" {
  value = aws_instance.web_server.public_ip
}