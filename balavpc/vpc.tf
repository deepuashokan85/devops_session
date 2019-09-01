# Internet VPC

resource "aws_vpc" "apssvpc" {
    cidr_block = "10.0.0.0/24"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags = {
        Name = "apssvpc"
    }

}


# Subnets
resource "aws_subnet" "apssvpc-public-1" {
    vpc_id = "${aws_vpc.apssvpc.id}"
    cidr_block = "10.0.0.0/28"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-2a"
    depends_on = ["aws_vpc.apssvpc"]
    tags = {
        Name = "apssvpc-public-1"
    }

}

resource "aws_subnet" "apssvpc-private-1" {
    vpc_id = "${aws_vpc.apssvpc.id}"
    cidr_block = "10.0.0.16/28"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-2b"
    depends_on = ["aws_vpc.apssvpc"]
    tags = {
        Name = "apssvpc-private-1"
    }
}


# Internet GW
resource "aws_internet_gateway" "apssvpc-igw" {
    vpc_id = "${aws_vpc.apssvpc.id}"
    depends_on = ["aws_vpc.apssvpc"]
    tags = {
        Name = "apssvpc-igw"
    }
}

# Elastic IP
resource "aws_eip" "nat-eip" {
    vpc = "true"
    tags = {
	Name = "nat-eip"
    }
}


# NAT GW

resource "aws_nat_gateway" "apssvpc-natgw" {
    allocation_id = "${aws_eip.nat-eip.id}"
    subnet_id = "${aws_subnet.apssvpc-public-1.id}"
    depends_on = ["aws_eip.nat-eip"]
    tags = {
	Name = "apssvpc-natgw"
    }
}

# route tables
resource "aws_route_table" "apssvpc-public-route" {
    vpc_id = "${aws_vpc.apssvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.apssvpc-igw.id}"
    }
    tags = {
        Name = "apssvpc-public-route"
    }
}

resource "aws_route_table" "apssvpc-private-route" {
    vpc_id = "${aws_vpc.apssvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.apssvpc-natgw.id}"
    }
    tags = {
        Name = "apssvpc-private-route"
    }
}

# route associations public
resource "aws_route_table_association" "public-2-a" {
    subnet_id = "${aws_subnet.apssvpc-public-1.id}"
    route_table_id = "${aws_route_table.apssvpc-public-route.id}"
    depends_on = ["aws_route_table.apssvpc-public-route"]
}
resource "aws_route_table_association" "public-2-b" {
    subnet_id = "${aws_subnet.apssvpc-private-1.id}"
    route_table_id = "${aws_route_table.apssvpc-private-route.id}"
    depends_on = ["aws_route_table.apssvpc-private-route"]
}

