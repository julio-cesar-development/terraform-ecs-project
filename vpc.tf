# Internet VPC
resource "aws_vpc" "main-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "main"
  }
}

# Subnets
resource "aws_subnet" "default-public" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "default-public"
  }
}

# resource "aws_subnet" "default-public-02" {
#   vpc_id                  = aws_vpc.main-vpc.id
#   cidr_block              = "10.0.2.0/24"
#   map_public_ip_on_launch = "true"
#   availability_zone       = "${var.AWS_REGION}c"

#   tags = {
#     Name = "default-public-02"
#   }
# }

# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main"
  }
}

# route tables
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "default-public"
  }
}

# route associations public
resource "aws_route_table_association" "default-public-a" {
  subnet_id      = aws_subnet.default-public.id
  route_table_id = aws_route_table.main-public.id
}
