#
# M O D U L E    V P C
#
module "vpc" {
  source                      = "../modules/infrastructure/vpc"
  vpc_id                      = module.vpc.vpc_id
  vpc_public_subnet_a_id      = module.vpc.vpc_public_subnet_a_id
  vpc_public_subnet_b_id      = module.vpc.vpc_public_subnet_b_id
  vpc_public_route_table_a_id = module.vpc.vpc_public_route_table_a_id
  vpc_public_route_table_b_id = module.vpc.vpc_public_route_table_b_id
  vpc_internet_gateway_id     = module.vpc.vpc_internet_gateway_id
  #variables
  tag_environment = var.tag_environment
  cluster_name    = var.cluster_name
}

#
# M O D U L E    E L B
#
module "elb" {
  depends_on = [
    module.vpc
  ]
  source = "../modules/infrastructure/elb"
  # VPC
  vpc_id                 = module.vpc.vpc_id
  vpc_public_subnet_a_id = module.vpc.vpc_public_subnet_a_id
  vpc_public_subnet_b_id = module.vpc.vpc_public_subnet_b_id
  # ALB
  elb_public_http_https_sg_id = module.elb.elb_public_http_https_sg_id
  elb_default_arn             = module.elb.elb_default_arn
  elb_default_id              = module.elb.elb_default_id
  elb_default_tg_arn          = module.elb.elb_default_tg_arn
  elb_default_tg_id           = module.elb.elb_default_tg_id
  # variables
  tag_environment = var.tag_environment
  cluster_name    = var.cluster_name
}

#
# M O D U L E    E C 2
#
module "ec2" {
  depends_on = [
    module.vpc,
    module.elb
  ]
  source = "../modules/infrastructure/ec2"
  # EC2
  ec2_public_ssh_sg_id = module.ec2.ec2_public_ssh_sg_id
  # ECS
  ecs_cluster_id   = module.ec2.ecs_cluster_id
  ecs_cluster_name = module.ec2.ecs_cluster_name
  # AutoScaling
  ecs_launch_configuration_template_id = module.ec2.ecs_launch_configuration_template_id
  ecs_auto_scaling_group_name          = module.ec2.ecs_auto_scaling_group_name
  ecs_auto_scaling_group_id            = module.ec2.ecs_auto_scaling_group_id
  ecs_auto_scaling_up_policy_id        = module.ec2.ecs_auto_scaling_up_policy_id
  ecs_auto_scaling_up_policy_arn       = module.ec2.ecs_auto_scaling_up_policy_arn
  ecs_auto_scaling_down_policy_arn     = module.ec2.ecs_auto_scaling_down_policy_arn
  ecs_auto_scaling_down_policy_id      = module.ec2.ecs_auto_scaling_down_policy_id
  # VPC
  vpc_id                 = module.vpc.vpc_id
  vpc_public_subnet_a_id = module.vpc.vpc_public_subnet_a_id
  vpc_public_subnet_b_id = module.vpc.vpc_public_subnet_b_id
  # variables
  tag_environment = var.tag_environment
  cluster_name    = var.cluster_name
}

#
# M O D U L E    E C S    C L U S T E R
#
module "ecs" {
  depends_on = [
    module.vpc,
    module.elb,
    module.ec2
  ]
  source = "../modules/backend/ecs"
  # ECS
  ecs_cluster_id = module.ec2.ecs_cluster_id
  # variables
  tag_environment = var.tag_environment
  cluster_name    = var.cluster_name
}
