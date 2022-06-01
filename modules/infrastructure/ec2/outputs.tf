#
# Outputs
#
output "ec2_public_ssh_sg_id" {
  value = aws_security_group.ec2_public_ssh_sg.id
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_launch_configuration_template_id" {
  value = aws_launch_configuration.ecs_launch_configuration_template.id
}