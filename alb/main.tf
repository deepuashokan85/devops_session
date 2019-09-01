provider "aws" {
  # Credentials to access aws cluster
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

data "aws_subnet_ids" "example" {
  vpc_id = "vpc-b7997cdc"
}

data "aws_subnet" "example" {
  count = "${length(data.aws_subnet_ids.example.ids)}"
  id    = "${data.aws_subnet_ids.example.ids[count.index]}"
}


resource "aws_lb" "test-lb" {
  name = "test-lb-tf"
  internal = false
  load_balancer_type = "application"
subnet_id = "${element(data.aws_subnet_ids.example.ids)}"
#subnet_id     = "${var.subnet_id}"  
#subnets        = ["${var.my_public_subnets.*.id}"]
#subnets     = "subnet1"
# security_groups    = ["${aws_security_group.lb_sg.id}"]  
#associate_public_ip_address = "${var.associate_public_ip_address}"
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = "${aws_lb_target_group.test.arn}"
  target_id        = "${aws_instance.test-inst.0.id}"
  port             = 80
depends_on = [aws_lb_target_group.test,
	     aws_instance.test-inst,]

}


resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = "vpc-b7997cdc"
depends_on = [aws_instance.test-inst]
}



resource "aws_instance" "test-inst" {
  instance_type = "${var.instance_type}"
  ami           = "${var.ami}"
  count         = 1
  subnet_id     = "${var.subnet_id}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

}

