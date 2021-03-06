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

variable "cidr_subnet_a" {
  type    = string
  default = "192.168.1.0/24"
}

variable "vpc_cidr_block_external" {
  type    = string
  default = "0.0.0.0/0"
}

variable "az" {
  type    = string
  default = "us-east-1a"
}

variable "vpc_id" {

}

variable "vpc_internet_gateway_id" {

}

variable "vpc_public_route_table_a_id" {

}

variable "vpc_public_subnet_a_id" {

}
