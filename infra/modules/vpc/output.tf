# VPC ID
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

# Public Subnet IDs
output "public_subnet_id" {
  description = "ID of public subnet 1 (us-east-1a)"
  value       = aws_subnet.public_subnet.id
}

output "public_subnet_2_id" {
  description = "ID of public subnet 2 (us-east-1b)"
  value       = aws_subnet.public_subnet_2.id
}

output "public_subnet_ids" {
  description = "List of all public subnet IDs"
  value       = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]
}

# Private Subnet IDs
output "private_subnet_id" {
  description = "ID of private subnet 1 (us-east-1a)"
  value       = aws_subnet.private_subnet.id
}

output "private_subnet_2_id" {
  description = "ID of private subnet 2 (us-east-1b)"
  value       = aws_subnet.private_subnet_2.id
}

output "private_subnet_ids" {
  description = "List of all private subnet IDs"
  value       = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_2.id]
}

# Internet Gateway ID
output "igw_id" {
  description = "ID of Internet Gateway"
  value       = aws_internet_gateway.main_igw.id
}

# NAT Gateway ID
output "nat_gateway_id" {
  description = "ID of NAT Gateway"
  value       = aws_nat_gateway.nat_gw.id
}

# Route Table IDs
output "public_route_table_id" {
  description = "ID of public route table"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  description = "ID of private route table"
  value       = aws_route_table.private_rt.id
}
