output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.arn
}

output "vpc_ipv4_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.ipv4_cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.vpc.default_security_group_id
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = module.vpc.default_network_acl_id
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = module.vpc.default_route_table_id
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = module.vpc.main_route_table_id
}

output "vpc_ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = module.vpc.ipv6_association_id
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = module.vpc.ipv6_cidr_block
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = module.vpc.owner_id
}

# Private Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.private_subnets.ids
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.private_subnets.arns
}

output "private_subnets_ipv4_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.private_subnets.ipv4_cidr_blocks
}

output "private_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC"
  value       = module.private_subnets.ipv6_cidr_blocks
}

# Public Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.public_subnets.ids
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = module.public_subnets.arns
}

output "public_subnets_ipv4_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.public_subnets.ipv4_cidr_blocks
}

output "public_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = module.public_subnets.ipv6_cidr_blocks
}

# Database Subnets
output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.database_subnets.ids
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = module.database_subnets.arns
}

output "database_subnets_ipv4_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = module.database_subnets.ipv4_cidr_blocks
}

output "database_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of database subnets in an IPv6 enabled VPC"
  value       = module.database_subnets.ipv6_cidr_blocks
}

output "database_subnet_group" {
  description = "ID of database subnet group"
  value       = [for group in module.database_subnets.rds_subnet_groups : group.id]
}

output "database_subnet_group_name" {
  description = "Name of database subnet group"
  value       = [for group in module.database_subnets.rds_subnet_groups : group.name]
}

# Route Tables
output "public_route_table_id" {
  description = "Public route table ID"
  value       = module.public_route_table.id
}

output "public_route_table_association_ids" {
  description = "List of IDs of the public route table association"
  value       = module.public_subnets.route_table_association_ids
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = [for table in module.private_route_tables : table.id]
}

output "private_route_table_association_ids" {
  description = "List of IDs of the private route table association"
  value       = module.private_subnets.route_table_association_ids
}

output "database_route_table_id" {
  description = "Database route table ID"
  value       = module.database_route_table.id
}

output "database_route_table_association_ids" {
  description = "List of IDs of the database route table association"
  value       = module.database_subnets.route_table_association_ids
}

output "dhcp_options_id" {
  description = "The ID of the DHCP options"
  value       = module.vpc.dhcp_options_id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.public_subnets.nat_gateway_public_ips
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.public_subnets.nat_gateway_ids
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = module.vpc.internet_gateway_arn
}
