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

output "cidr_block" {
  description = "The IPv4 CIDR block of the VPC"
  value       = module.vpc.cidr_block
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
# Flow Log
################################################################################

output "flow_log_arn" {
  description = "The VPC flow log ARN"
  value       = module.vpc.flow_log_arn
}

output "flow_log_id" {
  description = "The VPC flow log ID"
  value       = module.vpc.flow_log_id
}

################################################################################
# Flow Log CloudWatch Log Group
################################################################################

output "flow_log_cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created"
  value       = module.vpc.flow_log_cloudwatch_log_group_name
}

output "flow_log_cloudwatch_log_group_arn" {
  description = "ARN of cloudwatch log group created"
  value       = module.vpc.flow_log_cloudwatch_log_group_arn
}

################################################################################
# Flow Log CloudWatch Log Group IAM Role
################################################################################

output "flow_log_iam_role_name" {
  description = "Name of the flow log CloudWatch IAM role"
  value       = module.vpc.flow_log_iam_role_name
}

output "flow_log_iam_role_arn" {
  description = "ARN of the flow log CloudWatch IAM role"
  value       = module.vpc.flow_log_iam_role_arn
}

output "flow_log_iam_role_unique_id" {
  description = "Stable and unique string identifying the flow log CloudWatch IAM role"
  value       = module.vpc.flow_log_iam_role_unique_id
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
