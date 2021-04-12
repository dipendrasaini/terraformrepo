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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCz0OHDKW7Wcr1HC4hbYzojpeJvZdEcyYcUMrEHnl0cqzNrb6TTBiCuQDctuxQ9CktBWalPBD3Yev0eN5wDqhVFr+LCw7yQqbeT99IPdkxw6oCofZZ8WWmWWKHsyAEh3i85G/FHnTSwhw/UFcXaCjobhyWw2xM0++Eu39+mFEmlxaIHx+o0mH1Zb4Idl8mddDSuV9QsrMlNIiFTQahKB3W9195hzQmlifxBVfKF/q6ST2nEBCGHmv8W9xEpS6+u2PRLwzCfhEoSTlhroubetxH1nyXymrE2iVYVsU48qTdnv1HV2s0vV7UCzXL0hsq/14ucwt3q28PALrxEEwS79k+YOMhVtoKXwqa+r13qjzli77O+G4fJL5jOVP2xfjoSyxKKEkMSKRhMl9KO9KS8y+m+/VkRj/ALx/xOw5PtUr4O8VG4VF0crAT8HlJn0YP85PMIJbMedGjTpQq6ECl1MxC7ybWyqsL9kuVmrKVKUzje/7qwgKIt6KHowX8RO7LEiMM= root@host"
}

