resource "aws_vpc" "vpc_8byte" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc_8byte.id
  cidr_block = "192.168.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc_8byte.id
  cidr_block = "192.168.100.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_8byte.id
}


resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.vpc_8byte.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "RT_association_public" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "RT_association_private" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_db_subnet_group" "subnetgroup_for_rds" {
  name = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet.id]
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "subnetgroup_for_rds"{
  value = aws_db_subnet_group.subnetgroup_for_rds
}

output "vpc_id" {
  value = aws_vpc.vpc_8byte.id
}
