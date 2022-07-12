variable "cluster_name" {
  description = "Environment that all services are hosted | DEV | STAGE | PROD |"
  type        = string
  default     = "cluster-default"
}

variable "tag_environment" {
  description = "Environment that all services are hosted | DEV | STAGE | PROD |"
  type        = string
  default     = "dev"
}

variable "ec2_ami" {
  type = map(any)
  default = {
    "us-east-1" = "ami-026c8acd92718196b"
    "us-east-2" = "ami-0d8f6eb4f641ef691"
  }
}

variable "ec2_ecs_ami" {
  type    = string
  default = "ami-04ca8c64160cd4188"
}
variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_cidr_block_external" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ec2_key" {
  default = "brunosouto-key"
}

variable "ec2_public_ssh_sg_id" {

}

variable "vpc_id" {

}

variable "vpc_public_subnet_a_id" {

}

variable "vpc_public_subnet_b_id" {

}

variable "ecs_cluster_id" {

}

variable "ecs_cluster_name" {

}

variable "ecs_launch_configuration_template_id" {

}

variable "ecs_auto_scaling_group_id" {

}

variable "ecs_auto_scaling_group_name" {

}

variable "ecs_auto_scaling_up_policy_id" {

}

variable "ecs_auto_scaling_down_policy_id" {

}

variable "ecs_auto_scaling_up_policy_arn" {

}

variable "ecs_auto_scaling_down_policy_arn" {

}