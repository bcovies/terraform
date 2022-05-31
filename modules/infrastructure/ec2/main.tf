# 
# Security Group Public SSH
#
resource "aws_security_group" "ec2_public_ssh_sg" {
  name        = "${var.tag_environment}-${var.cluster_name}-ec2-ssh-sg"
  description = "Allows SSH protocol for external use"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allows any protocol for internal use"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block_external]
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
    Name        = "${var.tag_environment}_${var.cluster_name}_ec2_ssh_sg"
    Environment = "${var.tag_environment}"
  }
}

#
# Ec2 Instance 
#
# resource "aws_instance" "ec2_test_east_1" {
#   subnet_id                   = var.vpc_public_subnet_a_id
#   associate_public_ip_address = true
#   count                       = 1
#   ami                         = var.ec2_ami.us-east-1
#   instance_type               = "t2.micro"
#   key_name                    = var.ec2_key
#   vpc_security_group_ids      = [var.ec2_public_ssh_sg_id]
#   tags = {
#     Name        = "${var.tag_environment}_${var.cluster_name}_ec2"
#     Environment = "${var.tag_environment}"
#   }
# }
