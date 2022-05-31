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


variable "vpc_cidr_block_external" {
  type    = string
  default = "0.0.0.0/0"
}

variable "vpc_id" {

}

variable "elb_public_http_https_sg_id" {

}

variable "vpc_public_subnet_a_id" {

}

variable "vpc_public_subnet_b_id" {

}

variable "elb_default_arn" {

}

variable "elb_default_tg_id" {

}

variable "elb_default_id" {

}

variable "elb_default_tg_arn" {

}
