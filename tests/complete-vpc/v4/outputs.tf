output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.arn
}

output "vpc_cidr_block" {
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

output "vpc_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks of the VPC"
  value       = module.vpc.secondary_cidr_blocks
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
  value       = module.private_subnet.arns
}

output "private_subnets_cidr_blocks" {
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
  value       = module.public_subnet.arns
}

output "public_subnets_cidr_blocks" {
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
  value       = module.database_subnet.arns
}

output "database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = module.database_subnets.ipv4_cidr_blocks
}

output "database_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of database subnets in an IPv6 enabled VPC"
  value       = module.database_subnets.ipv6_cidr_blocks
}

output "database_subnet_group" {
  description = "ID of database subnet group"
  value       = module.database_subnets.rds_subnet_groups
}

# Redshift Subnets
output "redshift_subnets" {
  description = "List of IDs of redshift subnets"
  value       = module.redshift_subnets.ids
}

output "redshift_subnet_arns" {
  description = "List of ARNs of redshift subnets"
  value       = module.redshift_subnet.arns
}

output "redshift_subnets_cidr_blocks" {
  description = "List of cidr_blocks of redshift subnets"
  value       = module.redshift_subnets.ipv4_cidr_blocks
}

output "redshift_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of redshift subnets in an IPv6 enabled VPC"
  value       = module.redshift_subnets.ipv6_cidr_blocks
}

output "redshift_subnet_group" {
  description = "ID of redshift subnet group"
  value       = module.redshift_subnets.redshift_subnet_groups
}

# Elasticache Subnets
output "elasticache_subnets" {
  description = "List of IDs of elasticache subnets"
  value       = module.elasticache_subnets.ids
}

output "elasticache_subnet_arns" {
  description = "List of ARNs of elasticache subnets"
  value       = module.elasticache_subnet.arns
}

output "elasticache_subnets_cidr_blocks" {
  description = "List of cidr_blocks of elasticache subnets"
  value       = module.elasticache_subnets.ipv4_cidr_blocks
}

output "elasticache_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of elasticache subnets in an IPv6 enabled VPC"
  value       = module.elasticache_subnets.ipv6_cidr_blocks
}

output "elasticache_subnet_group" {
  description = "ID of elasticache subnet group"
  value       = module.elasticache_subnets.elasticache_subnet_groups
}

# Intra Subnets
output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value       = module.intra_subnets.ids
}

output "intra_subnet_arns" {
  description = "List of ARNs of intra subnets"
  value       = module.intra_subnet.arns
}

output "intra_subnets_cidr_blocks" {
  description = "List of cidr_blocks of intra subnets"
  value       = module.intra_subnets.ipv4_cidr_blocks
}

output "intra_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of intra subnets in an IPv6 enabled VPC"
  value       = module.intra_subnets.ipv6_cidr_blocks
}

# Route Tables
output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = [module.public_route_table.id]
}

output "public_route_table_association_ids" {
  description = "List of IDs of the public route table association"
  value       = module.public_subnets.route_table_association_ids
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = [module.private_route_table.id]
}

output "private_route_table_association_ids" {
  description = "List of IDs of the private route table association"
  value       = module.private_subnets.route_table_association_ids
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = [module.database_route_table.id]
}

output "database_route_table_association_ids" {
  description = "List of IDs of the database route table association"
  value       = module.database_subnets.route_table_association_ids
}

output "redshift_route_table_ids" {
  description = "List of IDs of redshift route tables"
  value       = [module.redshift_route_table.id]
}

output "redshift_route_table_association_ids" {
  description = "List of IDs of the redshift route table association"
  value       = module.redshift_subnets.route_table_association_ids
}

output "elasticache_route_table_ids" {
  description = "List of IDs of elasticache route tables"
  value       = module.vpc.elasticache_route_table_ids
}

output "elasticache_route_table_association_ids" {
  description = "List of IDs of the elasticache route table association"
  value       = module.elasticache_subnets.route_table_association_ids
}

output "intra_route_table_ids" {
  description = "List of IDs of intra route tables"
  value       = module.vpc.intra_route_table_ids
}

output "intra_route_table_association_ids" {
  description = "List of IDs of the intra route table association"
  value       = module.intra_subnets.route_table_association_ids
}

output "dhcp_options_id" {
  description = "The ID of the DHCP options"
  value       = module.vpc.dhcp_options_id
}

# Gateways

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

output "egress_only_internet_gateway_id" {
  description = "The ID of the egress only Internet Gateway"
  value       = module.vpc.egress_only_internet_gateway_id
}

output "cgw_ids" {
  description = "List of IDs of Customer Gateway"
  value       = module.vpc.customer_gateway_ids
}

output "cgw_arns" {
  description = "List of ARNs of Customer Gateway"
  value       = module.vpc.customer_gateway_arns
}

output "this_customer_gateway" {
  description = "Map of Customer Gateway attributes"
  value       = module.vpc.customer_gateways
}

output "vgw_id" {
  description = "The ID of the VPN Gateway"
  value       = module.vpc.vpn_gateway_ids
}

output "vgw_arn" {
  description = "The ARN of the VPN Gateway"
  value       = module.vpc.vpn_gateway_arns
}

# Default Resources
output "default_vpc_id" {
  description = "The ID of the Default VPC"
  value       = module.vpc.default_vpc_id
}

output "default_vpc_arn" {
  description = "The ARN of the Default VPC"
  value       = module.vpc.default_vpc_arn
}

output "default_vpc_cidr_block" {
  description = "The CIDR block of the Default VPC"
  value       = module.vpc.default_vpc_cidr_block
}

output "default_vpc_default_security_group_id" {
  description = "The ID of the security group created by default on Default VPC creation"
  value       = module.vpc.default_vpc_default_security_group_id
}

output "default_vpc_default_network_acl_id" {
  description = "The ID of the default network ACL of the Default VPC"
  value       = module.vpc.default_vpc_default_network_acl_id
}

output "default_vpc_default_route_table_id" {
  description = "The ID of the default route table of the Default VPC"
  value       = module.vpc.default_vpc_default_route_table_id
}

output "default_vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within Default VPC"
  value       = module.vpc.default_vpc_instance_tenancy
}

output "default_vpc_enable_dns_support" {
  description = "Whether or not the Default VPC has DNS support"
  value       = module.vpc.default_vpc_enable_dns_support
}

output "default_vpc_enable_dns_hostnames" {
  description = "Whether or not the Default VPC has DNS hostname support"
  value       = module.vpc.default_vpc_enable_dns_hostnames
}

output "default_vpc_main_route_table_id" {
  description = "The ID of the main route table associated with the Default VPC"
  value       = module.vpc.default_vpc_main_route_table_id
}

# Network ACLs
output "public_network_acl_id" {
  description = "ID of the public network ACL"
  value       = module.public_subnets.network_acl_id
}

output "public_network_acl_arn" {
  description = "ARN of the public network ACL"
  value       = module.public_subnets.network_acl_arn
}

output "private_network_acl_id" {
  description = "ID of the private network ACL"
  value       = module.private_subnets.network_acl_id
}

output "private_network_acl_arn" {
  description = "ARN of the private network ACL"
  value       = module.private_subnets.network_acl_arn
}

output "intra_network_acl_id" {
  description = "ID of the intra network ACL"
  value       = module.intra_subnets.network_acl_id
}

output "intra_network_acl_arn" {
  description = "ARN of the intra network ACL"
  value       = module.intra_subnets.network_acl_arn
}

output "database_network_acl_id" {
  description = "ID of the database network ACL"
  value       = module.database_subnets.network_acl_id
}

output "database_network_acl_arn" {
  description = "ARN of the database network ACL"
  value       = module.database_subnets.network_acl_arn
}

output "redshift_network_acl_id" {
  description = "ID of the redshift network ACL"
  value       = module.redshift_subnets.network_acl_id
}

output "redshift_network_acl_arn" {
  description = "ARN of the redshift network ACL"
  value       = module.redshift_subnets.network_acl_arn
}

output "elasticache_network_acl_id" {
  description = "ID of the elasticache network ACL"
  value       = module.elasticache_subnets.network_acl_id
}

output "elasticache_network_acl_arn" {
  description = "ARN of the elasticache network ACL"
  value       = module.elasticache_subnets.network_acl_arn
}

# VPC flow log
output "vpc_flow_log_id" {
  description = "The ID of the Flow Log resource"
  value       = module.vpc.vpc_flow_log_id
}

output "vpc_flow_log_destination_arn" {
  description = "The ARN of the destination for VPC Flow Logs"
  value       = module.vpc.vpc_flow_log_destination_arn
}

output "vpc_flow_log_destination_type" {
  description = "The type of the destination for VPC Flow Logs"
  value       = module.vpc.vpc_flow_log_destination_type
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
  value       = module.vpc.vpc_flow_log_cloudwatch_iam_role_arn
}

# VPC endpoints
output "vpc_endpoints" {
  description = "Array containing the full resource object and attributes for all endpoints created"
  value       = module.vpc_endpoints.endpoints
}
