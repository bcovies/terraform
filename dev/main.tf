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
  # ECS
  ecs_cluster_id   = module.ec2.ecs_cluster_id
  ecs_cluster_name = module.ec2.ecs_cluster_name
  # VPC
  vpc_id                 = module.vpc.vpc_id
  vpc_public_subnet_a_id = module.vpc.vpc_public_subnet_a_id
  vpc_public_subnet_b_id = module.vpc.vpc_public_subnet_b_id
  # variables
  tag_environment = var.tag_environment
  cluster_name    = var.cluster_name
}

#
# M O D U L E    P I P E L I N E 
#
module "backend_pipeline" {

  depends_on = [
    module.vpc,
    module.elb,
    module.ec2
  ]

  source = "../modules/pipelines"

  # variables
  tag_environment = var.tag_environment
  cluster_name    = var.cluster_name
  region          = var.region
  # VPC
  vpc_id = module.vpc.vpc_id
  # Pipeline Variables
  app_gitHub_token    = "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"
  app_gitHub_owner    = "my-digital-waiter"
  app_gitHub_repo     = "terraform-infra"
  app_gitHub_branch   = "devops"
  infra_gitHub_token  = "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"
  infra_gitHub_owner  = "my-digital-waiter"
  infra_gitHub_repo   = "terraform-infra"
  infra_gitHub_branch = "devops"
  AlbHealthCheckPath  = ""
  # CodeBuild Variables
  buildspec_path = "buildspec/build-backend.yml"
}
