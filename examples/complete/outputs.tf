################################################################################
# VPC
################################################################################

output "id" {
  description = "The ID of the VPC"
  value       = module.vpc.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of VPC"
  value       = module.vpc.arn
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.cidr_block
}

output "main_route_table_id" {
  description = "The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an `aws_main_route_table_association`"
  value       = module.vpc.main_route_table_id
}

output "default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = module.vpc.default_network_acl_id
}

output "default_route_table_id" {
  description = "The ID of the route table created by default on VPC creation"
  value       = module.vpc.default_route_table_id
}

output "ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = module.vpc.ipv6_association_id
}

output "ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = module.vpc.ipv6_cidr_block
}

output "secondary_ipv4_cidr_block_assocations" {
  description = "The IPv6 CIDR block"
  value       = module.vpc.secondary_ipv4_cidr_block_assocations
}

################################################################################
# Default Security Group
################################################################################

output "default_security_group_arn" {
  description = "The ARN of the security group created by default on VPC creation"
  value       = module.vpc.default_security_group_arn
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.vpc.default_security_group_id
}
