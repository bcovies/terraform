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
  name        = "${var.tag_environment}_${var.cluster_name}"
  description = "Allows any protocol for internal use"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allows any protocol for internal use"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
  }

  egress {
    description      = "Allows any protocol to internet"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.tag_environment}_${var.cluster_name}_vpc_sg"
    Environment = "${var.tag_environment}"
  }
}

#
# Public Subnet A
#
resource "aws_subnet" "vpc_public_subnet_a" {
  depends_on        = [aws_vpc.vpc]
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_subnet
  availability_zone = var.az
  tags = {
    Name        = "${var.tag_environment}_${var.cluster_name}_public_subnet_a"
    Environment = "${var.tag_environment}"
  }
}


#
# Outputs
#
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_sg_id" {
  value = aws_security_group.vpc_internal_sg.id
}

output "subnet_id" {
  value = aws_subnet.vpc_public_subnet_a.id
}

