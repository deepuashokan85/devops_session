##RHEL INSTANCE CREATION#
resource "aws_instance" "rhel-instance" {
instance_type = "${var.instance_type}"
ami           = "${var.amirhel}"
count         = 1
associate_public_ip_address = "${var.associate_public_ip_address}"
tags = {
        Name = "rhel-instance"
    }
provisioner "local-exec" {
    command = "echo ${aws_instance.testInstance.public_ip} >> public_ip.txt"
  }
}
##CENTOS INSTANCE CREATION#
resource "aws_instance" "centos-instance" {
instance_type = "${var.instance_type}"
ami           = "${var.amicentos}"
count         = 1
associate_public_ip_address = "${var.associate_public_ip_address}"
tags = {
        Name = "centos-instance"
    }
provisioner "local-exec" {
    command = "echo ${aws_instance.testInstance.public_ip} >> public_ip.txt"
  }
}
output "RHEL_instance_ip" {
  value       = "${aws_instance.rhel-instance.*.public_ip}"
  description = "The Public IP address of the RHEL instance."
}

output "instance_ip" {
  value       = "${aws_instance.centos-instance.*.public_ip}"
  description = "The Public IP address of the Centos instance."
}

