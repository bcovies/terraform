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
# Ec2 Bastion Instance 
#
resource "aws_instance" "ec2_bastion" {
  depends_on = [
    var.ec2_public_ssh_sg_id
  ]
  subnet_id                   = var.vpc_public_subnet_a_id
  associate_public_ip_address = true
  ami                         = var.ec2_ami.us-east-1
  instance_type               = var.ec2_instance_type
  key_name                    = var.ec2_key
  vpc_security_group_ids      = [var.ec2_public_ssh_sg_id]
  tags = {
    Name        = "${var.tag_environment}_${var.cluster_name}_bastion_ec2"
    Environment = "${var.tag_environment}"
  }
}

#
# Ecs Cluster
#
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.tag_environment}-${var.cluster_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#
# Ecs Cluster Launch Configuration Temaplate
#
resource "aws_launch_configuration" "ecs_launch_configuration_template" {
  depends_on = [
    var.ecs_cluster_id
  ]
  name                        = "${var.tag_environment}-${var.cluster_name}-ecs-cluster-template"
  image_id                    = var.ec2_ecs_ami
  instance_type               = var.ec2_instance_type
  key_name                    = var.ec2_key
  associate_public_ip_address = false
  enable_monitoring           = true
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = false
  }
  user_data = <<EOF
#!/bin/bash
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
start amazon-ssm-agent
chkconfig amazon-ssm-agent on
echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
EOF

}

#
# Ecs Cluster Auto Scaling Group
#
resource "aws_autoscaling_group" "ecs_auto_scaling_group" {
  depends_on = [
    var.ecs_launch_configuration_template_id
  ]
  name                      = "${var.tag_environment}-${var.cluster_name}-ecs-asg"
  max_size                  = 3
  desired_capacity          = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = var.ecs_launch_configuration_template_id
  vpc_zone_identifier       = [var.vpc_public_subnet_a_id, var.vpc_public_subnet_b_id]
}

