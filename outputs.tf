################################################################################
# VPC
################################################################################

output "arn" {
  description = "Amazon Resource Name (ARN) of VPC"
  value       = try(aws_vpc.this[0].arn, null)
}

output "id" {
  description = "The ID of the VPC"
  value       = local.vpc_id
}

output "main_route_table_id" {
  description = "The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an `aws_main_route_table_association`"
  value       = try(aws_vpc.this[0].main_route_table_id, null)
}

output "ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = try(aws_vpc.this[0].ipv6_association_id, null)
}

output "ipv6_cidr_block_network_border_group" {
  description = "The Network Border Group Zone name"
  value       = try(aws_vpc.this[0].ipv6_cidr_block_network_border_group, null)
}

output "ipv4_cidr_block" {
  description = "The IPv4 CIDR block of the VPC"
  value       = try(aws_vpc.this[0].cidr_block, null)
}

output "ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the VPC"
  value       = try(aws_vpc.this[0].ipv6_cidr_block, null)
}

output "owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = try(aws_vpc.this[0].owner_id, null)
}

################################################################################
# VPC CIDR Block Association(s)
################################################################################

output "ipv4_cidr_block_associations" {
  description = "Map of IPv4 CIDR block associations and their attributes"
  value       = aws_vpc_ipv4_cidr_block_association.this
}

output "ipv6_cidr_block_associations" {
  description = "Map of IPv6 CIDR block associations and their attributes"
  value       = aws_vpc_ipv6_cidr_block_association.this
}

################################################################################
# Route53 Resolver
################################################################################

output "dnssec_config_arn" {
  description = "The ARN for a configuration for DNSSEC validation"
  value       = try(aws_route53_resolver_dnssec_config.this[0].arn, null)
}

output "dnssec_config_id" {
  description = "The ID for a configuration for DNSSEC validation"
  value       = try(aws_route53_resolver_dnssec_config.this[0].id, null)
}

output "dns_query_log_config_arn" {
  description = "The ARN (Amazon Resource Name) of the Route 53 Resolver query logging configuration"
  value       = try(aws_route53_resolver_query_log_config.this[0].arn, null)
}

output "dns_query_log_config_id" {
  description = "The ID of the Route 53 Resolver query logging configuration"
  value       = try(aws_route53_resolver_query_log_config.this[0].id, null)
}

output "dns_query_log_config_association_id" {
  description = "he ID of the Route 53 Resolver query logging configuration association"
  value       = try(aws_route53_resolver_query_log_config_association.this[0].id, null)
}

################################################################################
# Flow Log
################################################################################

output "flow_log_arn" {
  description = "The VPC flow log ARN"
  value       = try(aws_flow_log.this[0].arn, null)
}

output "flow_log_id" {
  description = "The VPC flow log ID"
  value       = try(aws_flow_log.this[0].id, null)
}

################################################################################
# Flow Log CloudWatch Log Group
################################################################################

output "flow_log_cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created"
  value       = try(aws_cloudwatch_log_group.flow_log[0].name, null)
}

output "flow_log_cloudwatch_log_group_arn" {
  description = "ARN of cloudwatch log group created"
  value       = try(aws_cloudwatch_log_group.flow_log[0].arn, null)
}

################################################################################
# Flow Log CloudWatch Log Group IAM Role
################################################################################

output "flow_log_iam_role_name" {
  description = "Name of the flow log CloudWatch IAM role"
  value       = try(aws_iam_role.flow_log_cloudwatch[0].name, null)
}

output "flow_log_iam_role_arn" {
  description = "ARN of the flow log CloudWatch IAM role"
  value       = try(aws_iam_role.flow_log_cloudwatch[0].arn, null)
}

output "flow_log_iam_role_unique_id" {
  description = "Stable and unique string identifying the flow log CloudWatch IAM role"
  value       = try(aws_iam_role.flow_log_cloudwatch[0].unique_id, null)
}

################################################################################
# DHCP Options Set
################################################################################

output "dhcp_options_id" {
  description = "The ID of the DHCP options set"
  value       = try(aws_vpc_dhcp_options.this[0].id, null)
}

output "dhcp_options_arn" {
  description = "The ARN of the DHCP options set"
  value       = try(aws_vpc_dhcp_options.this[0].arn, null)
}

output "dhcp_options_association_id" {
  description = "The ID of the DHCP Options set association"
  value       = try(aws_vpc_dhcp_options_association.this[0].id, null)
}

################################################################################
# Internet Gateway
################################################################################

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].arn, null)
}

output "egress_only_internet_gateway_id" {
  description = "The ID of the Egress-Only Internet Gateway"
  value       = try(aws_egress_only_internet_gateway.this[0].id, null)
}

################################################################################
# Customer Gateway(s)
################################################################################

output "customer_gateways" {
  description = "Map of Customer Gateways and their attributes"
  value       = aws_customer_gateway.this
}

output "customer_gateway_ids" {
  description = "List of Customer Gateway IDs"
  value       = [for cgw in aws_customer_gateway.this : cgw.id]
}

output "customer_gateway_arns" {
  description = "List of Customer Gateways ARNs"
  value       = [for cgw in aws_customer_gateway.this : cgw.arn]
}

################################################################################
# VPN Gateway(s)
################################################################################

output "vpn_gateways" {
  description = "Map of VPN Gateways and their attributes"
  value       = aws_vpn_gateway.this
}

output "vpn_gateway_ids" {
  description = "List of VPN Gateway IDs"
  value       = [for vgw in aws_vpn_gateway.this : vgw.id]
}

output "vpn_gateway_arns" {
  description = "List of VPN Gateways ARNs"
  value       = [for vgw in aws_vpn_gateway.this : vgw.arn]
}
################################################################################
# VPC Default Security Group
################################################################################

output "default_security_group_arn" {
  description = "The ARN of the security group created by default on VPC creation"
  value       = try(aws_default_security_group.this[0].arn, null)
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = try(aws_vpc.this[0].default_security_group_id, aws_default_security_group.this[0].id, null)
}

################################################################################
# VPC Default Network ACL
################################################################################

output "default_network_acl_arn" {
  description = "ARN of the Default Network ACL"
  value       = try(aws_default_network_acl.this[0].arn, null)
}

output "default_network_acl_id" {
  description = "ID of the Default Network ACL"
  value       = try(aws_vpc.this[0].default_network_acl_id, aws_default_network_acl.this[0].id, null)
}

################################################################################
# VPC Default Route Table
################################################################################

output "default_route_table_arn" {
  description = "ARN of the default route table"
  value       = try(aws_default_route_table.this[0].arn, null)
}

output "default_route_table_id" {
  description = "ID of the default route table"
  value       = try(aws_vpc.this[0].default_route_table_id, aws_default_route_table.this[0].id, null)
}

################################################################################
# Account Default DHCP Options
################################################################################

output "default_dhcp_options_id" {
  description = "The ID of the default DHCP options set"
  value       = try(aws_default_vpc_dhcp_options.this[0].id, null)
}

output "default_dhcp_options_arn" {
  description = "The ARN of the default DHCP options set"
  value       = try(aws_default_vpc_dhcp_options.this[0].arn, null)
}

################################################################################
# Account Default VPC
################################################################################

output "default_vpc_id" {
  description = "The ID of the Default VPC"
  value       = try(aws_default_vpc.this[0].id, null)
}

output "default_vpc_arn" {
  description = "The ARN of the Default VPC"
  value       = try(aws_default_vpc.this[0].arn, null)
}

output "default_vpc_ipv4_cidr_block" {
  description = "The CIDR block of the Default VPC"
  value       = try(aws_default_vpc.this[0].cidr_block, null)
}

output "default_vpc_default_security_group_id" {
  description = "The ID of the security group created by default on Default VPC creation"
  value       = try(aws_default_vpc.this[0].default_security_group_id, null)
}

output "default_vpc_default_network_acl_id" {
  description = "The ID of the default network ACL of the Default VPC"
  value       = try(aws_default_vpc.this[0].default_network_acl_id, null)
}

output "default_vpc_default_route_table_id" {
  description = "The ID of the default route table of the Default VPC"
  value       = try(aws_default_vpc.this[0].default_route_table_id, null)
}

output "default_vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within Default VPC"
  value       = try(aws_default_vpc.this[0].instance_tenancy, null)
}

output "default_vpc_enable_dns_support" {
  description = "Whether or not the Default VPC has DNS support"
  value       = try(aws_default_vpc.this[0].enable_dns_support, null)
}

output "default_vpc_enable_dns_hostnames" {
  description = "Whether or not the Default VPC has DNS hostname support"
  value       = try(aws_default_vpc.this[0].enable_dns_hostnames, null)
}

output "default_vpc_main_route_table_id" {
  description = "The ID of the main route table associated with the Default VPC"
  value       = try(aws_default_vpc.this[0].main_route_table_id, null)
}
