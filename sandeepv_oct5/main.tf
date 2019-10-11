provider "aws" {
   # Credentials to access aws cluster
   access_key = "XYZ"
   secret_key = "ABC"
   region = "us-east-2"
 }


resource "aws_instance" "RHEL_inst" {
count         = 2
ami           = "ami-0520e698dd500b1d1"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name = "14jul"
  depends_on = [aws_security_group.allow_tls]
}

resource "aws_instance" "Centos_int" {
count         = 2
ami           = "free centos ami here"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name = "14jul"
  depends_on = [aws_security_group.allow_tls]
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"


  ingress {
    # TLS (change to whatever ports you need)
    from_port   = "443"
    to_port     = "443"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

ingress {
    # TLS (change to whatever ports you need)
    from_port   = "22"
    to_port     = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

ingress {
    # TLS (change to whatever ports you need)
    from_port   = "80"
    to_port     = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }


  egress {
    from_port       = "0"
    to_port         = "0"
  protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
 }
}
