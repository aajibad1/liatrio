data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Setup
resource "aws_vpc" "main" {
  cidr_block           = var.VPC_CIDR_BLOCK
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  #enable_classiclink  = "false"
  tags = {
    Name = "${var.RESOURCE_TAG}-vpc-${var.ENVIRONMENT}"
  }
}

# VPC Public Subnets
resource "aws_subnet" "main-public" {
  vpc_id                  = aws_vpc.main.id
  count                   = var.AZ_COUNT
  cidr_block        	    = "${cidrsubnet(aws_vpc.main.cidr_block, var.SUBNET_CIDR_BITS, count.index)}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  tags = {
    Name = "${var.RESOURCE_TAG}.public.${data.aws_availability_zones.available.names[count.index]}"
    "kubernetes.io/cluster/${var.RESOURCE_TAG}-cluster-${var.ENVIRONMENT}" = "owned"
    "kubernetes.io/role/elb" = 1

  }
}

# VPC Private Subnets
resource "aws_subnet" "main-private" {
  vpc_id                  = aws_vpc.main.id
  count            	      = var.AZ_COUNT
  cidr_block     	        = "${cidrsubnet(aws_vpc.main.cidr_block, var.SUBNET_CIDR_BITS, count.index + length(aws_subnet.main-public.*.id))}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  tags = {
    Name = "${var.RESOURCE_TAG}.private.${data.aws_availability_zones.available.names[count.index]}"
    "kubernetes.io/cluster/${var.RESOURCE_TAG}-cluster-${var.ENVIRONMENT}" = "owned"
    "kubernetes.io/role/internal-elb" = 1
  }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.RESOURCE_TAG}-IGW"
  }
  depends_on = [aws_vpc.main]
}

# NAT GW
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id = aws_subnet.main-public[0].id
  tags = {
    Name = "${var.RESOURCE_TAG}-NAT"
  }
  depends_on = [aws_vpc.main]
}

#Elastic IP for NAT
resource "aws_eip" "nat-eip" {
  vpc 	= true
  tags = {
    Name = "${var.RESOURCE_TAG}-NGW-IP"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "main-rt-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }
  tags = {
    Name = "${var.RESOURCE_TAG}-Main-Public-RT"
  }
}
# Route Table for Private Subnets
resource "aws_route_table" "main-rt-private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.RESOURCE_TAG}-Private-RT"
  }
}

#Route for Private Route Table
resource "aws_route" "private-route" {
  route_table_id          =  aws_route_table.main-rt-private.id
  destination_cidr_block  =  "0.0.0.0/0"
  nat_gateway_id         =  aws_nat_gateway.nat-gw.id
  depends_on             = [aws_route_table.main-rt-private]
}

# Route Associations Public
resource "aws_route_table_association" "main-rta-public-1" {
  count          = var.AZ_COUNT
  subnet_id      = "${element(aws_subnet.main-public.*.id, count.index)}"
  route_table_id = aws_route_table.main-rt-public.id
}

# Route Associations Private
resource "aws_route_table_association" "main-rta-private-1" {
  count            =  var.AZ_COUNT
  subnet_id        = "${element(aws_subnet.main-private.*.id, count.index)}"
  route_table_id   = aws_route_table.main-rt-private.id
}