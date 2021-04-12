
provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}

#keys for db and web instances
resource "aws_key_pair" "tf-key" {
  key_name   = "web"
  public_key = ""
}

#DB-instance
resource "aws_instance" "tf-dbj" {
  ami           = "ami-0bcf5425cdc1d8a85"
  instance_type = "t2.micro"
  key_name ="web"
   tags = {
    Name = "Terraform-Provisioner"
  }

provisioner "file" {
source = "/root/aws/ebs/active"
destination = "/tmp"
}
provisioner "remote-exec" {
inline =[
"sudo yum install httpd -y",
"sudo systemctl start httpd",
"sudo systemctl enable httpd",
"sudo cp -rvf /tmp/active/* /var/www/html/",
"sudo systemctl restart httpd"
]
}

provisioner "local-exec" {
command = "echo ${aws_instance.tf-dbj.public_ip} >> /tmp/ip"
}

connection {
host =self.public_ip
user="ec2-user"
type="ssh"
private_key=file("/root/aws/ebs/id_rsa")

}

}


