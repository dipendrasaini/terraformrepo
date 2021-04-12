provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}

variable input{}

resource "aws_instance" "tf-db" {
  ami           = "ami-0bcf5425cdc1d8a85"
  instance_type = "t2.micro"
  count = var.input == "aws" ? 1 : 0 
  tags = {
    Name = "variable input()" 
  }
}
