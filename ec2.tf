provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}

#DB-instance
resource "aws_instance" "tf-db" {
  ami           = "ami-0bcf5425cdc1d8a85"
  instance_type = var.instance_type
  tags = {
    Name = "DB-instance"
  }
}

