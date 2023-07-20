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
output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = [for subnet in module.private_subnet : subnet.arn]
}

output "private_subnets_ipv4_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = [for subnet in module.private_subnet : subnet.ipv4_cidr_block]
}

output "private_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC"
  value       = compact([for subnet in module.private_subnet : subnet.ipv6_cidr_block])
}

# Public Subnets
output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = [for subnet in module.public_subnet : subnet.arn]
}

output "public_subnets_ipv4_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = [for subnet in module.public_subnet : subnet.ipv4_cidr_block]
}

output "public_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = compact([for subnet in module.public_subnet : subnet.ipv6_cidr_block])
}

# Database Subnets
output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = [for subnet in module.database_subnet : subnet.arn]
}

output "database_subnets_ipv4_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = [for subnet in module.database_subnet : subnet.ipv4_cidr_block]
}

output "database_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of database subnets in an IPv6 enabled VPC"
  value       = compact([for subnet in module.database_subnet : subnet.ipv6_cidr_block])
}

# Redshift Subnets
output "redshift_subnet_arns" {
  description = "List of ARNs of redshift subnets"
  value       = [for subnet in module.redshift_subnet : subnet.arn]
}

output "redshift_subnets_ipv4_cidr_blocks" {
  description = "List of cidr_blocks of redshift subnets"
  value       = [for subnet in module.redshift_subnet : subnet.ipv4_cidr_block]
}

output "redshift_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of redshift subnets in an IPv6 enabled VPC"
  value       = compact([for subnet in module.redshift_subnet : subnet.ipv6_cidr_block])
}

# Elasticache Subnets
output "elasticache_subnet_arns" {
  description = "List of ARNs of elasticache subnets"
  value       = [for subnet in module.elasticache_subnet : subnet.arn]
}

output "elasticache_subnets_ipv4_cidr_blocks" {
  description = "List of cidr_blocks of elasticache subnets"
  value       = [for subnet in module.elasticache_subnet : subnet.ipv4_cidr_block]
}

output "elasticache_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of elasticache subnets in an IPv6 enabled VPC"
  value       = compact([for subnet in module.elasticache_subnet : subnet.ipv6_cidr_block])
}

# Route Tables
output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = [for subnet in module.public_subnet : subnet.route_table_id]
}

output "private_route_table_id" {
  description = "List of IDs of private route tables"
  value       = [for subnet in module.private_subnet : subnet.route_table_id]
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = [for subnet in module.database_subnet : subnet.route_table_id]
}

output "redshift_route_table_ids" {
  description = "List of IDs of redshift route tables"
  value       = [for subnet in module.redshift_subnet : subnet.route_table_id]
}

output "elasticache_route_table_ids" {
  description = "List of IDs of elasticache route tables"
  value       = [for subnet in module.elasticache_subnet : subnet.route_table_id]
}

output "dhcp_options_id" {
  description = "The ID of the DHCP options"
  value       = module.vpc.dhcp_options_id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = compact([for subnet in module.public_subnet : subnet.eip_public_ip])
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = compact([for subnet in module.public_subnet : subnet.nat_gateway_id])
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = module.vpc.internet_gateway_arn
}
