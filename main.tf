terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "brunosouto-ec2-terraform" {
    count = 1
    ami = "ami-0c02fb55956c7d316"
    instance_type = "t2.micro"
    key_name = "brunosouto-us-east-1"
}