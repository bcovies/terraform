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
  tag_environment             = var.tag_environment
  cluster_name                = var.cluster_name
}

#
# M O D U L E    E C 2
#
module "ec2" {
  depends_on = [
    module.vpc
  ]
  source                 = "../modules/infrastructure/ec2"
  ec2_public_ssh_sg_id   = module.ec2.ec2_public_ssh_sg_id
  vpc_id                 = module.vpc.vpc_id
  vpc_public_subnet_a_id = module.vpc.vpc_public_subnet_a_id
  tag_environment        = var.tag_environment
  cluster_name           = var.cluster_name
}

#
# M O D U L E    E L B
#
module "elb" {
  depends_on = [
    module.vpc
  ]
  source                      = "../modules/infrastructure/elb"
  vpc_id                      = module.vpc.vpc_id
  vpc_public_subnet_a_id      = module.vpc.vpc_public_subnet_a_id
  vpc_public_subnet_b_id      = module.vpc.vpc_public_subnet_b_id
  elb_public_http_https_sg_id = module.elb.elb_public_http_https_sg_id
  elb_default_arn             = module.elb.elb_default_arn
  elb_default_id              = module.elb.elb_default_id
  elb_default_tg_arn          = module.elb.elb_default_tg_arn
  elb_default_tg_id           = module.elb.elb_default_tg_id
  tag_environment             = var.tag_environment
  cluster_name                = var.cluster_name
}
