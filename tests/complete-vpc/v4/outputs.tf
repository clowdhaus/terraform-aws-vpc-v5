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
  value       = [for assoc in module.vpc.ipv4_cidr_block_associations : assoc.cidr_block]
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = module.vpc.owner_id
}

output "dhcp_options_id" {
  description = "The ID of the DHCP options"
  value       = module.vpc.dhcp_options_id
}

# Private Subnets
output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = [for subnet in module.private_subnet : subnet.arn]
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = [for subnet in module.private_subnet : subnet.ipv4_cidr_block]
}

output "private_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC"
  value       = [for subnet in module.private_subnet : subnet.ipv6_cidr_block]
}

# Public Subnets
output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = [for subnet in module.public_subnet : subnet.arn]
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = [for subnet in module.public_subnet : subnet.ipv4_cidr_block]
}

output "public_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = [for subnet in module.public_subnet : subnet.ipv6_cidr_block]
}

# Database Subnets
output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = [for subnet in module.database_subnet : subnet.arn]
}

output "database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = [for subnet in module.database_subnet : subnet.ipv4_cidr_block]
}

output "database_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of database subnets in an IPv6 enabled VPC"
  value       = [for subnet in module.database_subnet : subnet.ipv6_cidr_block]
}

# Redshift Subnets
output "redshift_subnet_arns" {
  description = "List of ARNs of redshift subnets"
  value       = [for subnet in module.redshift_subnet : subnet.arn]
}

output "redshift_subnets_cidr_blocks" {
  description = "List of cidr_blocks of redshift subnets"
  value       = [for subnet in module.redshift_subnet : subnet.ipv4_cidr_block]
}

output "redshift_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of redshift subnets in an IPv6 enabled VPC"
  value       = [for subnet in module.redshift_subnet : subnet.ipv6_cidr_block]
}

# Elasticache Subnets
output "elasticache_subnet_arns" {
  description = "List of ARNs of elasticache subnets"
  value       = [for subnet in module.elasticache_subnet : subnet.arn]
}

output "elasticache_subnets_cidr_blocks" {
  description = "List of cidr_blocks of elasticache subnets"
  value       = [for subnet in module.elasticache_subnet : subnet.ipv4_cidr_block]
}

output "elasticache_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of elasticache subnets in an IPv6 enabled VPC"
  value       = [for subnet in module.elasticache_subnet : subnet.ipv6_cidr_block]
}

# Intra Subnets
output "intra_subnet_arns" {
  description = "List of ARNs of intra subnets"
  value       = [for subnet in module.intra_subnet : subnet.arn]
}

output "intra_subnets_cidr_blocks" {
  description = "List of cidr_blocks of intra subnets"
  value       = [for subnet in module.intra_subnet : subnet.ipv4_cidr_block]
}

output "intra_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of intra subnets in an IPv6 enabled VPC"
  value       = [for subnet in module.intra_subnet : subnet.ipv6_cidr_block]
}

# Route Tables
output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = [for subnet in module.public_subnet : subnet.route_table_id]
}

output "private_route_table_ids" {
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

output "intra_route_table_ids" {
  description = "List of IDs of intra route tables"
  value       = [for subnet in module.intra_subnet : subnet.route_table_id]
}

# Gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = [for subnet in module.public_subnet : subnet.eip_public_ip]
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = [for subnet in module.public_subnet : subnet.nat_gateway_id]
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
  value       = module.vpc.default_vpc_ipv4_cidr_block
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

# VPC flow log
output "vpc_flow_log_id" {
  description = "The ID of the Flow Log resource"
  value       = module.vpc_flow_log.id
}

output "vpc_flow_log_destination_arn" {
  description = "The ARN of the destination for VPC Flow Logs"
  value       = module.vpc_flow_log.cloudwatch_log_group_arn
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
  value       = module.vpc_flow_log.iam_role_arn
}

# VPC endpoints
output "vpc_endpoints" {
  description = "Array containing the full resource object and attributes for all endpoints created"
  value       = module.vpc_endpoints.vpc_endpoints
}
