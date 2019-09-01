# First Terraform File

provider "aws" {
	profile = "default"
	region = "us-east-2"
	}

resource "aws_instance" "example" {
	instance_type = "t2.micro"
	ami = "ami-0520e698dd500b1d1"

	tags = {
	name = "terraform-example01"
	}
	}
