#
# Secutiry Group Public SSH
#
resource "aws_security_group" "ec2_public_ssh_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block_external]
  }
  tags = {
    "Name"        = ""
    "Environment" = ""
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
#     "Name"        = ""
#     "Environment" = ""
#   }
# }

#
# Outputs
#
output "ec2_public_ssh_sg_id" {
  value = aws_security_group.ec2_public_ssh_sg.id
}

