#
# M O D U L E    V P C
#
module "vpc" {
  source = "../modules/vpc"
  vpc_id = module.vpc.vpc_id
  vpc_public_subnet_a_id = module.vpc.vpc_public_subnet_a_id
  vpc_public_route_table_a_id = module.vpc.vpc_public_route_table_a_id
  vpc_internet_gateway_id = module.vpc.vpc_internet_gateway_id
  tag_environment = var.tag_environment
  cluster_name = var.cluster_name
}

#
# M O D U L E    E C 2
#
module "ec2" {
  depends_on = [
    module.vpc
  ]
  source = "../modules/ec2"
  ec2_public_ssh_sg_id = module.ec2.ec2_public_ssh_sg_id
  vpc_id = module.vpc.vpc_id
  vpc_public_subnet_a_id = module.vpc.vpc_public_subnet_a_id

}