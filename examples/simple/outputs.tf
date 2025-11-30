################################################################################
# VPC
################################################################################

output "arn" {
  description = "Amazon Resource Name (ARN) of VPC"
  value       = module.vpc.arn
}

output "id" {
  description = "The ID of the VPC"
  value       = module.vpc.id
}

output "main_route_table_id" {
  description = "The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an `aws_main_route_table_association`"
  value       = module.vpc.main_route_table_id
}

output "ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = module.vpc.ipv6_association_id
}

output "ipv6_cidr_block_network_border_group" {
  description = "The Network Border Group Zone name"
  value       = module.vpc.ipv6_cidr_block_network_border_group
}

output "ipv4_cidr_block" {
  description = "The IPv4 CIDR block of the VPC"
  value       = module.vpc.ipv4_cidr_block
}

output "ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the VPC"
  value       = module.vpc.ipv6_cidr_block
}

################################################################################
# VPC CIDR Block Association(s)
################################################################################

output "ipv4_cidr_block_associations" {
  description = "Map of IPv4 CIDR block associations and their attributes"
  value       = module.vpc.ipv4_cidr_block_associations
}

output "ipv6_cidr_block_associations" {
  description = "Map of IPv6 CIDR block associations and their attributes"
  value       = module.vpc.ipv6_cidr_block_associations
}

################################################################################
# Route53 Resolver DNSSEC Config
################################################################################

output "dnssec_config_arn" {
  description = "The ARN for a configuration for DNSSEC validation"
  value       = module.vpc.dnssec_config_arn
}

output "dnssec_config_id" {
  description = "The ID for a configuration for DNSSEC validation"
  value       = module.vpc.dnssec_config_id
}

output "dns_query_log_config_arn" {
  description = "The ARN (Amazon Resource Name) of the Route 53 Resolver query logging configuration"
  value       = module.vpc.dns_query_log_config_arn
}

output "dns_query_log_config_id" {
  description = "The ID of the Route 53 Resolver query logging configuration"
  value       = module.vpc.dns_query_log_config_id
}

output "dns_query_log_config_association_id" {
  description = "he ID of the Route 53 Resolver query logging configuration association"
  value       = module.vpc.dns_query_log_config_association_id
}

################################################################################
# DHCP Options Set
################################################################################

output "dhcp_options_id" {
  description = "The ID of the DHCP options set"
  value       = module.vpc.dhcp_options_id
}

output "dhcp_options_arn" {
  description = "The ARN of the DHCP options set"
  value       = module.vpc.dhcp_options_arn
}

output "dhcp_options_association_id" {
  description = "The ID of the DHCP Options set association"
  value       = module.vpc.dhcp_options_association_id
}

################################################################################
# Internet Gateway
################################################################################

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway"
  value       = module.vpc.internet_gateway_arn
}

output "egress_only_internet_gateway_id" {
  description = "The ID of the Egress-Only Internet Gateway"
  value       = module.vpc.egress_only_internet_gateway_id
}

################################################################################
# Customer Gateway(s)
################################################################################

output "customer_gateways" {
  description = "Map of Customer Gateways and their attributes"
  value       = module.vpc.customer_gateways
}

################################################################################
# VPN Gateway(s)
################################################################################

output "vpn_gateways" {
  description = "Map of VPN Gateways and their attributes"
  value       = module.vpc.vpn_gateways
}

################################################################################
# VPC Default Security Group
################################################################################

output "default_security_group_arn" {
  description = "The ARN of the security group created by default on VPC creation"
  value       = module.vpc.default_security_group_arn
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.vpc.default_security_group_id
}

################################################################################
# VPC Default Network ACL
################################################################################

output "default_network_acl_arn" {
  description = "ARN of the Default Network ACL"
  value       = module.vpc.default_network_acl_arn
}

output "default_network_acl_id" {
  description = "ID of the Default Network ACL"
  value       = module.vpc.default_network_acl_id
}

################################################################################
# VPC Default Route Table
################################################################################

output "default_route_table_arn" {
  description = "ARN of the default route table"
  value       = module.vpc.default_route_table_arn
}

output "default_route_table_id" {
  description = "ID of the default route table"
  value       = module.vpc.default_route_table_id
}

################################################################################
# Subnet
################################################################################

# Public
output "public_subnet_arns" {
  description = "Public subnet ARNs"
  value       = [for subnet in module.public_subnet : subnet.arn]
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [for subnet in module.public_subnet : subnet.id]
}

output "public_subnet_ipv4_cidr_blocks" {
  description = "Public subnet IPv4 CIDR blocks"
  value       = [for subnet in module.public_subnet : subnet.ipv4_cidr_block]
}

output "public_subnet_ipv6_cidr_blocks" {
  description = "Public subnet IPv6 CIDR blocks"
  value       = compact([for subnet in module.public_subnet : subnet.ipv6_cidr_block])
}

output "public_subnet_route_table_id" {
  description = "Public subnet route table IDs"
  value       = [for subnet in module.public_subnet : subnet.route_table_id]
}

output "public_route_table_subnet_association_ids" {
  description = "Public subnet route table association IDs"
  value       = [for subnet in module.public_subnet : subnet.route_table_subnet_association_id]
}

# Private
output "private_subnet_arns" {
  description = "Private subnet ARNs"
  value       = [for subnet in module.private_subnet : subnet.arn]
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = [for subnet in module.private_subnet : subnet.id]
}

output "private_subnet_ipv4_cidr_blocks" {
  description = "Private subnet IPv4 CIDR blocks"
  value       = compact([for subnet in module.private_subnet : subnet.ipv4_cidr_block])
}

output "private_subnet_ipv6_cidr_blocks" {
  description = "Private subnet IPv6 CIDR blocks"
  value       = compact([for subnet in module.private_subnet : subnet.ipv6_cidr_block])
}

output "private_subnet_route_table_id" {
  description = "Private subnet route table IDs"
  value       = [for subnet in module.private_subnet : subnet.route_table_id]
}

output "private_route_table_subnet_association_ids" {
  description = "Private subnet route table association IDs"
  value       = [for subnet in module.private_subnet : subnet.route_table_subnet_association_id]
}

################################################################################
# NAT Gateway
################################################################################

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = module.public_subnet["${local.region}a"].nat_gateway_id
}

output "eip_private_ip" {
  description = "Contains the private IP address"
  value       = module.public_subnet["${local.region}a"].eip_private_ip
}
