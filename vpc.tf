provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}


#keys for db and web instances
resource "aws_key_pair" "tf-key" {
  key_name   = "tf-key"
  public_key = ""
}

# security group for vpc
resource "aws_security_group" "tf-sg" {
  name        = "tf-sg"
  description = "Created bY terraform"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    description = "TLS from VPC"
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

  tags = {
    Name = "terraform-sg"
  }
}


#Main vpc
resource "aws_vpc" "tf-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Terraform-Vpc"
  }
}


#private subnet
resource "aws_subnet" "Private-subnet" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Privat-subnet"
  }
}


#public subnet
resource "aws_subnet" "Public-subnet" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Public-subnet"
}
}

# IGW
resource "aws_internet_gateway" "tf-igw" {
  vpc_id = aws_vpc.tf-vpc.id

  tags = {
    Name = "tf-igw"
  }
}



# route table for public subnet
resource "aws_route_table" "tf-public-rt" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-igw.id
  }

  tags = {
    Name = "Public-rt"
  }
}




#create NetGateway
resource "aws_nat_gateway" "tf-net" {
  allocation_id = aws_eip.net-eip.id
  subnet_id     = aws_subnet.Public-subnet.id

  tags = {
    Name = "Network Gateway"
  }
}



# route table for private subnet
resource "aws_route_table" "tf-private-rt" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf-net.id
  }

  tags = {
    Name = "Private-rt"
  }
}



# create elastic ip for nat
resource "aws_eip" "net-eip" {
  vpc      = true
}


#create elatic ip for public instance
resource "aws_eip" "pub-instance" {
  instance= aws_instance.tf-web.id
  vpc      = true
}



#DB-instance
resource "aws_instance" "tf-db" {
  ami           = "ami-0bcf5425cdc1d8a85"
  instance_type = "t2.micro"
  key_name="tf-key"
  subnet_id  = aws_subnet.Private-subnet.id
  vpc_security_group_ids = [aws_security_group.tf-sg.id]
  tags = {
    Name = "DB-instance"
  }
}


#web-instance
resource "aws_instance" "tf-web" {
  ami           = "ami-0bcf5425cdc1d8a85"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.Public-subnet.id
  key_name="tf-key"
  vpc_security_group_ids = [aws_security_group.tf-sg.id]  
  tags = {
    Name = "web-instance"
  }
}



# table assoicate with nat gateway
resource "aws_route_table_association" "net-asso" {
  subnet_id      = aws_subnet.Private-subnet.id
  route_table_id = aws_route_table.tf-private-rt.id
}


# table assoicate with public subent
resource "aws_route_table_association" "public-asso" {
  subnet_id      = aws_subnet.Public-subnet.id
  route_table_id = aws_route_table.tf-public-rt.id
}

