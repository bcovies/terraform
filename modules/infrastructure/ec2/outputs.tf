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

output "ecs_auto_scaling_group_id" {
  value = aws_autoscaling_group.ecs_auto_scaling_group.id
}

output "ecs_auto_scaling_group_name" {
  value = aws_autoscaling_group.ecs_auto_scaling_group.name
}

output "ecs_auto_scaling_up_policy_id" {
  value = aws_autoscaling_policy.ecs_auto_scaling_up_policy.id
}

output "ecs_auto_scaling_up_policy_arn" {
  value = aws_autoscaling_policy.ecs_auto_scaling_up_policy.arn
}

output "ecs_auto_scaling_down_policy_id" {
  value = aws_autoscaling_policy.ecs_auto_scaling_down_policy.id
}

output "ecs_auto_scaling_down_policy_arn" {
  value = aws_autoscaling_policy.ecs_auto_scaling_down_policy.arn
}