provider "aws" {
   region = "us-east-2"
 }


resource "aws_instance" "RHEL_inst" {
count         = 1
ami           = "ami-0520e698dd500b1d1"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.allow_tls1.id}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name = "key"
  depends_on = [aws_security_group.allow_tls1]
}


resource "aws_security_group" "allow_tls1" {
  name        = "allow_tls1"
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
