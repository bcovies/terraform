module "vpc" {
  source = "../modules/vpc"
  vpc_id = module.vpc.vpc_id
  tag_environment = var.tag_environment
  cluster_name = var.cluster_name
}
