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

#
#   Task Definitions Variables
#
variable "ecs_task_definition_family" {
  type    = string
  default = "default-family"
}

variable "ecs_task_definition_cpu" {
  type    = string
  default = "512"
}

variable "ecs_task_definition_memory" {
  type    = string
  default = "512"
}

variable "ecs_task_definition_network_mode" {
  type    = string
  default = "bridge"
}

#
#   Container Definitions Variables
#
variable "ecs_task_definition_container_definition_name" {
  type    = string
  default = "default"
}

variable "ecs_task_definition_container_definition_image" {
  type    = string
  default = "httpd"
}

variable "ecs_task_definition_container_definition_cpu" {
  type    = number
  default = 512
}

variable "ecs_task_definition_container_definition_memory" {
  type    = number
  default = 256
}

variable "ecs_task_definition_container_definition_memory_reservation" {
  type    = number
  default = 256
}

variable "ecs_task_definition_container_definition_container_port" {
  type    = number
  default = 80
}

variable "ecs_task_definition_container_definition_host_port" {
  type    = number
  default = 80
}
