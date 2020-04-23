# Use terraform to provision EC2 instance
# We'll provision 2 client instances and 1 server instance.
#
# Steps:
# 1. Install terraform: https://learn.hashicorp.com/terraform/getting-started/install.html
# 2. export AWS_ACCESS_KEY_ID=(your access key id)
#    export AWS_SECRET_ACCESS_KEY=(your secret access key)
# 3. Replace key_name with a SSH key that exists in your AWS account in `variables.tf`
# 4. Run commands: 
#       terraform init
#       terraform apply
# 5. To terminate these resources, Run: 
#       terraform destroy
#

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "instance" {
  name = "neper-sg"
  # used by neper
  ingress {
    from_port   = 12866
    to_port     = 12867
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # used to ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow all
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_client1" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]

  tags = {
    Name = "client1"
  }

  key_name = var.key_name
}

resource "aws_instance" "my_client2" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]

  tags = {
    Name = "client2"
  }

  key_name = var.key_name
}

resource "aws_instance" "my_server" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]

  tags = {
    Name = "server"
  }

  key_name = var.key_name
}