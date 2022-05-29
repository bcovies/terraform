#
# VPC
#
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.tag_environment}_${var.cluster_name}_vpc"
    Environment = "${var.tag_environment}"
  }
}

# 
# Security Group
#
resource "aws_security_group" "vpc_internal_sg" {
  depends_on = [var.vpc_id]
  name        = "${var.tag_environment}_${var.cluster_name}"
  description = "Allows any protocol for internal use"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allows any protocol for internal use"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description      = "Allows any protocol to internet"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.vpc_cidr_block_external]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.tag_environment}_${var.cluster_name}_vpc_sg"
    Environment = "${var.tag_environment}"
  }
}

#
# Internet Gateway
#
resource "aws_internet_gateway" "vpc_internet_gateway" {
  depends_on = [var.vpc_id]
  # vpc_id     = var.vpc_id

  tags = {
    Name        = "${var.tag_environment}_${var.cluster_name}_vpc_internet_gateway"
    Environment = "${var.tag_environment}"
  }
}

#
# Internet Gateway Attachment 
#
resource "aws_internet_gateway_attachment" "vpc_internet_gateway_attachment" {
  internet_gateway_id = var.vpc_internet_gateway_id
  vpc_id              = var.vpc_id
}

#
# Public Subnet A
#
resource "aws_subnet" "vpc_public_subnet_a" {
  depends_on = [var.vpc_id]
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_subnet_a
  availability_zone = var.az
  tags = {
    Name        = "${var.tag_environment}_${var.cluster_name}_public_subnet_a"
    Environment = "${var.tag_environment}"
  }
}

#
# Route Table
#
resource "aws_route_table" "vpc_public_route_table_a" {
  vpc_id     = var.vpc_id
  depends_on = [var.vpc_id]

  tags = {
    Name        = "${var.tag_environment}_${var.cluster_name}_vpc_route_table"
    Environment = "${var.tag_environment}"
  }
}

#
# Route 
#
resource "aws_route" "vpc_route_public_a" {
  route_table_id         = var.vpc_public_route_table_a_id
  gateway_id             = var.vpc_internet_gateway_id
  destination_cidr_block = var.vpc_cidr_block_external
  depends_on             = [var.vpc_public_route_table_a_id]
}

#
# Route Table Association
#
resource "aws_route_table_association" "vpc_route_table_public_a_association" {
  subnet_id      = var.vpc_public_subnet_a_id
  route_table_id = var.vpc_public_route_table_a_id
}

#
# Outputs
#
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_internet_gateway_id" {
  value = aws_internet_gateway.vpc_internet_gateway.id
}

output "vpc_public_route_table_a_id" {
  value = aws_route_table.vpc_public_route_table_a.id
}

output "vpc_public_subnet_a_id" {
  value = aws_subnet.vpc_public_subnet_a.id
}

