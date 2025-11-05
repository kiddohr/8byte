resource "aws_vpc" "vpc_8byte" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id = aws_vpc.vpc_8byte.id
  cidr_block = "192.168.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "public_subnet_b" {
  vpc_id = aws_vpc.vpc_8byte.id
  cidr_block = "192.168.50.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id = aws_vpc.vpc_8byte.id
  cidr_block = "192.168.100.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id = aws_vpc.vpc_8byte.id
  cidr_block = "192.168.150.0/24"
  availability_zone = "us-east-1c"
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

resource "aws_route_table_association" "RT_association_public_a" {
  subnet_id = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.RT.id
}
resource "aws_route_table_association" "RT_association_public_b" {
  subnet_id = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "RT_association_private_a" {
  subnet_id = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "RT_association_private_b" {
  subnet_id = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.RT.id
}


resource "aws_db_subnet_group" "subnetgroup_for_rds" {
  name = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet_a.id,aws_subnet.private_subnet_b.id]
}

output "public_subnet_a_id" {
  value = aws_subnet.public_subnet_a.id
}
output "public_subnet_b_id" {
  value = aws_subnet.public_subnet_b.id
}
output "private_subnet_a_id" {
  value = aws_subnet.private_subnet_a.id
}
output "private_subnet_b_id" {
  value = aws_subnet.private_subnet_b.id
}

output "subnetgroup_for_rds_name"{
  value = aws_db_subnet_group.subnetgroup_for_rds.name
}

output "vpc_id" {
  value = aws_vpc.vpc_8byte.id
}
