
#vpc creation
resource "aws_vpc" "main-vpc" {
  cidr_block       = var.cidr
  enable_dns_hostnames = var.dns-hostname[0]
  enable_dns_support = var.dns-support[0]

  tags = {
    Name   = "NetSPI"
    Project = "NetSPI_VPC"
  }
}

#subnets creation
resource "aws_subnet" "main-subnet" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = var.subnetcidr
  
  tags = {
    Name   = "NetSPI"
    Project = "NetSPI_Subnet"
  }
}


#IGW creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Project = "NetSPI_Subnet"
  }
}


#create route for IGW

resource "aws_route_table" "route2igw" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#associate public subnets to the route

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main-subnet.id
  route_table_id = aws_route_table.route2igw.id
}


#security group
resource "aws_security_group" "sg" {
  name        = "dynamic-sg"
  description = "Ingress for Vault"
  vpc_id = aws_vpc.main-vpc.id
  dynamic "ingress" {
    for_each = var.port-sg
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

