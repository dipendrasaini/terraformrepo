provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}

resource "aws_security_group" "Terraformsg" {
  name        = "Dipendra SG"
  description = "Dream Group"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform SG"
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_instance" "Tfinstane" {
  ami           = "ami-0bcf5425cdc1d8a85" # ap-south-1
  instance_type = "t2.micro"
  key_name      = "Terraform-key"
  vpc_security_group_ids = [aws_security_group.Terraformsg.id]
   
  }

resource "aws_key_pair" "deployer" {
  key_name   = "Terraform-key"
  public_key = ""
}

