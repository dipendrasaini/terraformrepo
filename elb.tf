
provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}

variable "elbname"{
type = string
}

variable "azname" {
type=list
default =["ap-south-1a","ap-south-1b","ap-south-1c"]
}

variable "timeout"{
type =number
}


# Create a new load balancer
resource "aws_elb" "bar" {
  name               = var.elbname
  availability_zones = var.azname

listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = var.timeout
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
}
