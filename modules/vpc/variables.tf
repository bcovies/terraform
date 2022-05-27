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

variable "vpc_cidr_block" {
  description = "Classes Inter-Domain Routing that is used to the cluster."
  type        = string
  default     = "192.168.0.0/16"
}

variable "cidr_subnet" {
  type    = string
  default = "192.168.1.0/24"
}

variable "az" {
  type    = string
  default = "us-east-1a"
}

variable "vpc_id" {

}
