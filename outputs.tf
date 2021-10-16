################################################################################
# VPC
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this.*.id, null)
}

output "vpc_arn" {
  description = "Amazon Resource Name (ARN) of VPC"
  value       = try(aws_vpc.this.*.arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this.*.cidr_block, null)
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an `aws_main_route_table_association`"
  value       = try(aws_vpc.this.*.main_route_table_id, null)
}

output "vpc_default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = try(aws_vpc.this.*.default_network_acl_id, null)
}

output "vpc_default_route_table_id" {
  description = "The ID of the route table created by default on VPC creation"
  value       = try(aws_vpc.this.*.default_route_table_id, null)
}

output "vpc_ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = try(aws_vpc.this.*.ipv6_association_id, null)
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = try(aws_vpc.this.*.ipv6_cidr_block, null)
}

output "vpc_secondary_ipv4_cidr_block_assocations" {
  description = "The IPv6 CIDR block"
  value       = aws_vpc_ipv4_cidr_block_association.this
}

################################################################################
# Default Security Group
################################################################################

output "vpc_default_security_group_arn" {
  description = "The ARN of the security group created by default on VPC creation"
  value       = try(aws_default_security_group.this.*.arn, null)
}

output "vpc_default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = try(aws_vpc.this.*.default_security_group_id, null)
}
