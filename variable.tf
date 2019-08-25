provider "aws" {
  # Credentials to access aws cluster
  access_key = ""
  secret_key = ""
  region = "us-east-2"
}

resource "aws_instance" "test-inst" {
  instance_type = "t2.micro"
  ami           = "ami-0520e698dd500b1d1"
  count         = 2
# vpc_id        = "${var.vpcid}" # Not required, subnet id will pick vpc_id
  subnet_id     = "subnet-2711b26b"
#  vpc_security_group_ids = "sg-033f5832144273df6"
  associate_public_ip_address = "true"
}
