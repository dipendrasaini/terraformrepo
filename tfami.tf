
provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}

resource "aws_ami_from_instance" "example" {
  name               = "terraform-example"
  source_instance_id = "i-05dc2cd28606d3a91"
}
