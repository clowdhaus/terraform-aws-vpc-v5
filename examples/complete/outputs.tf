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
# Flow Log
################################################################################

output "flow_log_arn" {
  description = "The VPC flow log ARN"
  value       = module.vpc_flow_log.arn
}

output "flow_log_id" {
  description = "The VPC flow log ID"
  value       = module.vpc_flow_log.id
}

################################################################################
# Flow Log CloudWatch Log Group
################################################################################

output "flow_log_cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created"
  value       = module.vpc_flow_log.cloudwatch_log_group_name
}

output "flow_log_cloudwatch_log_group_arn" {
  description = "ARN of cloudwatch log group created"
  value       = module.vpc_flow_log.cloudwatch_log_group_arn
}

################################################################################
# Flow Log CloudWatch Log Group IAM Role
################################################################################

output "flow_log_iam_role_name" {
  description = "Name of the flow log CloudWatch IAM role"
  value       = module.vpc_flow_log.iam_role_name
}

output "flow_log_iam_role_arn" {
  description = "ARN of the flow log CloudWatch IAM role"
  value       = module.vpc_flow_log.iam_role_arn
}

output "flow_log_iam_role_unique_id" {
  description = "Stable and unique string identifying the flow log CloudWatch IAM role"
  value       = module.vpc_flow_log.iam_role_unique_id
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
# Account Default DHCP Options
################################################################################

output "default_dhcp_options_id" {
  description = "The ID of the default DHCP options set"
  value       = module.vpc.default_dhcp_options_id
}

output "default_dhcp_options_arn" {
  description = "The ARN of the default DHCP options set"
  value       = module.vpc.default_dhcp_options_arn
}

################################################################################
# Account Default VPC
################################################################################

output "default_vpc_id" {
  description = "The ID of the Default VPC"
  value       = module.vpc.default_vpc_id
}

output "default_vpc_arn" {
  description = "The ARN of the Default VPC"
  value       = module.vpc.default_vpc_arn
}

output "default_vpc_ipv4_cidr_block" {
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

################################################################################
# Subnet
################################################################################

output "public_subnets" {
  description = "Map of public subnets created and their attributes"
  value       = module.public_subnets.subnets
}

output "public_subnet_arns" {
  description = "List of subnet ARNs"
  value       = module.public_subnets.arns
}

output "public_subnet_ids" {
  description = "List of subnet IDs"
  value       = module.public_subnets.ids
}

output "public_subnet_ipv4_cidr_blocks" {
  description = "List of subnet IPv4 CIDR blocks"
  value       = module.public_subnets.ipv4_cidr_blocks
}

output "public_subnet_ipv6_cidr_blocks" {
  description = "List of subnet IPv6 CIDR blocks"
  value       = module.public_subnets.ipv6_cidr_blocks
}

################################################################################
# EC2 Subnet CIDR Reservation
################################################################################

output "public_subnets_ec2_subnet_cidr_reservations" {
  description = "Map of EC2 subnet CIDR reservations created and their attributes"
  value       = module.public_subnets.ec2_subnet_cidr_reservations
}

################################################################################
# Route Table
################################################################################

output "public_route_table_id" {
  description = "Public route table ID"
  value       = module.public_route_table.id
}

output "public_route_table_subnet_association_ids" {
  description = "List of subnet route table association IDs"
  value       = module.public_subnets.route_table_association_ids
}

output "public_route_table_gateway_association_ids" {
  description = "List of subnet route table association IDs"
  value       = module.public_route_table.gateway_association_ids
}

################################################################################
# Network ACL
################################################################################

output "public_network_acl_arn" {
  description = "The ID of the network ACL"
  value       = module.public_network_acl.arn
}

output "public_network_acl_id" {
  description = "The ARN of the network ACL"
  value       = module.public_network_acl.id
}

output "public_network_acl_rules_ingress" {
  description = "Map of ingress network ACL rules created and their attributes"
  value       = module.public_network_acl.rules_ingress
}

output "public_network_acl_rules_egress" {
  description = "Map of egress network ACL rules created and their attributes"
  value       = module.public_network_acl.rules_egress
}

################################################################################
# Network Firewall
################################################################################

output "network_firewall_id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall"
  value       = module.network_firewall.id
}

output "network_firewall_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall"
  value       = module.network_firewall.arn
}

output "network_firewall_status" {
  description = "Nested list of information about the current status of the firewall"
  value       = module.network_firewall.status
}

output "network_firewall_update_token" {
  description = "A string token used when updating a firewall"
  value       = module.network_firewall.update_token
}

################################################################################
# Network Firewall Policy
################################################################################

output "network_firewall_policy_id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy"
  value       = module.network_firewall.policy_id
}

output "network_firewall_policy_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy"
  value       = module.network_firewall.policy_arn
}

output "network_firewall_policy_update_token" {
  description = "A string token used when updating a firewall policy"
  value       = module.network_firewall.policy_update_token
}

################################################################################
# Network Firewall Rule Group
################################################################################

output "network_firewall_rule_groups" {
  description = "A map of the rule groups created and their attributes"
  value       = module.network_firewall.rule_groups
}

################################################################################
# Network Firewall Resource Policy
################################################################################

output "network_firewall_policy_resource_policy_id" {
  description = "The Amazon Resource Name (ARN) of the firewall policy associated with the resource policy"
  value       = module.network_firewall.firewall_policy_resource_policy_id
}

output "network_firewall_rule_group_resource_policies" {
  description = "Map of Rule Group resource policies created and their attributes"
  value       = module.network_firewall.rule_group_resource_policies
}

################################################################################
# Network Firewall Logging Configuration
################################################################################

output "network_firewall_logging_configuration_id" {
  description = "The Amazon Resource Name (ARN) of the associated firewall"
  value       = module.network_firewall.logging_configuration_id
}

################################################################################
# DNS Firewall
################################################################################

output "dns_firewall_config_id" {
  description = "The ID of the firewall configuration"
  value       = module.vpc.dns_firewall_config_id
}

output "dns_firewall_rule_group_associations" {
  description = "Map of Route53 resolver firewall rule group associations and their attributes"
  value       = module.vpc.dns_firewall_rule_group_associations
}

################################################################################
# DNS Firewall Rule Group
################################################################################

output "dns_firewall_rule_group_arn" {
  description = "The ARN (Amazon Resource Name) of the rule group"
  value       = module.dns_firewall_rule_group.arn
}

output "dns_firewall_rule_group_id" {
  description = "The ID of the rule group"
  value       = module.dns_firewall_rule_group.id
}

output "dns_firewall_rule_group_share_status" {
  description = "Whether the rule group is shared with other AWS accounts, or was shared with the current account by another AWS account. Sharing is configured through AWS Resource Access Manager (AWS RAM). Valid values: `NOT_SHARED`, `SHARED_BY_ME`, `SHARED_WITH_ME`"
  value       = module.dns_firewall_rule_group.share_status
}

output "dns_firewall_rule_group_domain_lists" {
  description = "Map of all domain lists created and their attributes"
  value       = module.dns_firewall_rule_group.domain_lists
}

output "dns_firewall_rule_group_rules" {
  description = "Map of all rules created and their attributes"
  value       = module.dns_firewall_rule_group.rules
}
