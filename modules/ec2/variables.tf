variable "ec2_ami" {
  type = map(any)
  default = {
    "us-east-1" = "ami-026c8acd92718196b"
    "us-east-2" = "ami-0d8f6eb4f641ef691"
  }
}

variable "vpc_cidr_block_external" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ec2_key" {
  default = "brunosouto-key"
}

variable "ec2_public_ssh_sg_id" {

}

variable "vpc_id" {
  
}

variable "vpc_public_subnet_a_id" {
  
}