variable "ec2_ami" {
  type = map
  default = {
      "us-east-1" = "ami-026c8acd92718196b"
      "us-east-2" = "ami-0d8f6eb4f641ef691"
  }
}

variable "cidr_blocks" {
    type = list
    default = ["0.0.0.0/0"]
}

variable "ec2_key" {
  default = "brunosouto-key"  
}