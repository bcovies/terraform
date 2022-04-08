terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_instance" "ec2_test" {
  count = 1
  ami = var.ec2_ami.us-east-1
  instance_type = "t2.micro"
  key_name = var.ec2_key
  vpc_security_group_ids = [ "${aws_security_group.public_ssh.id}" ]
  tags = {
    "Name" = "terraform-brunosouto-ec2"
    "Environment" = "TST"
  }
}

resource "aws_security_group" "public_ssh" {
  name = "public-ssh"
  description = "Acesso SSH Publico"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = "${var.cidr_blocks}" 
  }
  tags = {
    "Name" = "sg-public-access-ssh-brunosouto"
    "Environment" = "TST"
  }
}