provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}

terraform {
  backend "s3" {
    bucket = "terraformcheck"
    key    = "cloud/logs"
    region = "ap-south-1"
    access_key = ""
    secret_key = ""
    dynamodb_table = "hello"
  }
}

#DB-instance
resource "aws_instance" "tf-dbj" {
  ami           = "ami-0bcf5425cdc1d8a85"
  instance_type = "t2.micro"
  tags = {
    Name = "khush instance"
  }
}
