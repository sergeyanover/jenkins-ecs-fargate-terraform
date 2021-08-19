resource "aws_vpc" "ecs_vpc" {
  cidr_block       = var.ecs_vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "ecs_vpc"
  }
}

resource "aws_subnet" "ecs_subnet_1" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = var.ecs_subnet1_cidr
  availability_zone = var.avail_zone1

  tags = {
    Name = "ecs_subnet1"
  }
}

resource "aws_subnet" "ecs_subnet_2" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = var.ecs_subnet2_cidr
  availability_zone = var.avail_zone2
  map_public_ip_on_launch = true
  tags = {
    Name = "ecs_subnet2"
  }
}

resource "aws_subnet" "ecs_subnet_3" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = var.ecs_subnet3_cidr
  availability_zone = var.avail_zone3
  map_public_ip_on_launch = true
  tags = {
    Name = "ecs_subnet3"
  }
}


resource "aws_internet_gateway" "ecs_igw" {
  vpc_id     = aws_vpc.ecs_vpc.id
  tags = {
    Name = "ecs_igw"
  }  
}

resource "aws_default_route_table" "ecs_rtb" {
  default_route_table_id = aws_vpc.ecs_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_igw.id
  }  
  tags = {
    Name = "ecs_rtb"
  }  
}