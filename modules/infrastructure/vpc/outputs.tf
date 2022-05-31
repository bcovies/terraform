#
# Outputs
#
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_internet_gateway_id" {
  value = aws_internet_gateway.vpc_internet_gateway.id
}

output "vpc_public_route_table_a_id" {
  value = aws_route_table.vpc_public_route_table_a.id
}

output "vpc_public_subnet_a_id" {
  value = aws_subnet.vpc_public_subnet_a.id
}

output "vpc_public_route_table_b_id" {
  value = aws_route_table.vpc_public_route_table_b.id
}

output "vpc_public_subnet_b_id" {
  value = aws_subnet.vpc_public_subnet_b.id
}
