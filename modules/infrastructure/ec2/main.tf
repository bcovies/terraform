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
# Ecr
#
resource "aws_ecr_repository" "ecs_ecr" {
  name                 = "${var.tag_environment}-${var.cluster_name}-ecr-ecs-cluster"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}