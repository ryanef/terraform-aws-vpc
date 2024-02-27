output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet.id
}
output "private_subnets" {
  value = aws_subnet.private_subnet.id
}
output "database_subnets" {
  value = aws_subnet.database_subnet.id
}

output "database_subnet_group" {
  value = aws_db_subnet_group.rds_subnetgroup[*].name
}

output "igw" {
  value = aws_internet_gateway.internet_gateway.id
}

output "public_rt" {
  value = aws_route_table.public_rt.id
}

output "vpc_security_group" {
  value = aws_security_group.default.id
}