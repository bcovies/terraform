# 
# Security Group Public 80 and 443
#
resource "aws_security_group" "elb_public_http_https_sg" {
  name        = "${var.tag_environment}-${var.cluster_name}-elb-http-https-sg"
  description = "Allows HTTP and HTTPS protocol for external use"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allows 80 protocol for external use"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block_external]
  }

  ingress {
    description = "Allows 443 protocol for external use"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block_external]
  }

  egress {
    description      = "Allows any protocol to internet"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.vpc_cidr_block_external]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.tag_environment}_${var.cluster_name}_elb_http_https_sg"
    Environment = "${var.tag_environment}"
  }
}

#
#   LoadBalancer
#
resource "aws_lb" "elb_default" {
  depends_on = [
    var.elb_public_http_https_sg_id
  ]
  name               = "${var.tag_environment}-${var.cluster_name}-elb-default"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.elb_public_http_https_sg_id]
  subnets            = [var.vpc_public_subnet_a_id, var.vpc_public_subnet_b_id]

  enable_deletion_protection = false

  tags = {
    Name        = "${var.tag_environment}_${var.cluster_name}_elb_default"
    Environment = "${var.tag_environment}"
  }
}

#
# Target Group Default
#

resource "aws_lb_target_group" "elb_default_tg" {
  depends_on = [
    var.elb_default_id
  ]
  name     = "${var.tag_environment}-${var.cluster_name}-elb-default-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    Name        = "${var.tag_environment}_${var.cluster_name}_elb_default_tg"
    Environment = "${var.tag_environment}"
  }
}


#
# LoadBalancer Listener
#

resource "aws_lb_listener" "elb_default_http_listener" {
  depends_on = [
    var.elb_default_tg_id
  ]
  load_balancer_arn = var.elb_default_arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = var.elb_default_tg_arn
  }
}
