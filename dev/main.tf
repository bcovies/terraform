module "vpc" {
  source = "../modules/vpc"
  vpc_id = module.vpc.vpc_id
  vpc_public_subnet_a_id = module.vpc.vpc_public_subnet_a_id
  vpc_public_route_table_a_id = module.vpc.vpc_public_route_table_a_id
  vpc_internet_gateway_id = module.vpc.vpc_internet_gateway_id
  tag_environment = var.tag_environment
  cluster_name = var.cluster_name
}
