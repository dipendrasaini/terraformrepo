

provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}

#DB-instance
resource "aws_instance" "tf-dbj" {
  ami           = "ami-0bcf5425cdc1d8a85"
  instance_type = "t2.micro"
  
}


output "Db_instance_info" {
value = aws_instance.tf-dbj
}

