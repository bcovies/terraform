variable "cluster_name" {
  description = "Name of the cluster that will be used to name all services."
  type           = string
  default        = "bruno-souto"
}

variable "tag_environment" {
  type = string
  default = "tst"
}