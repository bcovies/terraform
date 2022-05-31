#
# Outputs
#
output "ec2_public_ssh_sg_id" {
  value = aws_security_group.ec2_public_ssh_sg.id
}
