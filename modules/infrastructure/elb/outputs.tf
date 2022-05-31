output "elb_public_http_https_sg_id" {
  value = aws_security_group.elb_public_http_https_sg.id
}

output "elb_default_arn" {
  value = aws_lb.elb_default.arn
}

output "elb_default_id" {
  value = aws_lb.elb_default.id
}

output "elb_default_tg_arn" {
  value = aws_lb_target_group.elb_default_tg.arn
}

output "elb_default_tg_id" {
  value = aws_lb_target_group.elb_default_tg.id
}
