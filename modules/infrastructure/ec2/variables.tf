#
#   Default variables
#
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

variable "ecs_cluster_id" {

}

variable "ecs_cluster_name" {

}