
##################
###  EAST -- 1 ###
##################
resource "aws_security_group" "public_ssh_east_1" {
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
    "Owner" = "Bruno Souto"
  }
}

resource "aws_instance" "ec2_test_east_1" {
  count = 1
  ami = var.ec2_ami.us-east-1
  instance_type = "t2.micro"
  key_name = var.ec2_key
  vpc_security_group_ids = [ "${aws_security_group.public_ssh_east_1.id}" ]
  tags = {
    "Name" = "terraform-brunosouto-ec2"
    "Environment" = "TST"
    "Owner" = "Bruno Souto"
  }
}


##################
###  EAST -- 2 ###
##################
resource "aws_security_group" "public_ssh_east_2" {
  name = "public-ssh"
  description = "Acesso SSH Publico"
  provider = aws.west
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

resource "aws_instance" "ec2_test_east_2" {
  provider = aws.west
  count = 1
  ami = var.ec2_ami.us-east-2
  instance_type = "t2.micro"
  key_name = var.ec2_key
  vpc_security_group_ids = [ "${aws_security_group.public_ssh_east_2.id}" ]
  tags = {
    "Name" = "terraform-brunosouto-ec2"
    "Environment" = "TST"
  }
}