################################################################################
# VPC
################################################################################

output "id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this[0].id, null)
}

output "arn" {
  description = "Amazon Resource Name (ARN) of VPC"
  value       = try(aws_vpc.this[0].arn, null)
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this[0].cidr_block, null)
}

output "main_route_table_id" {
  description = "The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an `aws_main_route_table_association`"
  value       = try(aws_vpc.this[0].main_route_table_id, null)
}

output "default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = try(aws_vpc.this[0].default_network_acl_id, null)
}

output "default_route_table_id" {
  description = "The ID of the route table created by default on VPC creation"
  value       = try(aws_vpc.this[0].default_route_table_id, null)
}

output "ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = try(aws_vpc.this[0].ipv6_association_id, null)
}

output "ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = try(aws_vpc.this[0].ipv6_cidr_block, null)
}

output "secondary_ipv4_cidr_block_assocations" {
  description = "Map of secondary IPV4 CIDR block associations and their attributes"
  value       = aws_vpc_ipv4_cidr_block_association.this
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

################################################################################
# Route Table
################################################################################

output "route_tables" {
  description = "Map of route tables created and their attributes"
  value       = aws_route_table.this
}

output "routes" {
  description = "Map of routes created and their attributes"
  value = merge(
    aws_route.this,
    aws_route.internet_gateway,
    aws_route.egress_only_internet_gateway
  )
}

################################################################################
# Subnet
################################################################################

output "subnets" {
  description = "Map of subnets created and their attributes"
  value       = aws_subnet.this
}

################################################################################
# Internet Gateway
################################################################################

output "igw_id" {
  description = "The ID of the internet gateway"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].arn, null)
}

output "egress_only_igw_id" {
  description = "The ID of the egress only internet gateway"
  value       = try(aws_egress_only_internet_gateway.this[0].id, null)
}

################################################################################
# Default Security Group for VPC created
################################################################################

output "default_security_group_arn" {
  description = "The ARN of the security group created by default on VPC creation"
  value       = try(aws_default_security_group.this[0].arn, null)
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = try(aws_vpc.this[0].default_security_group_id, null)
}

################################################################################
# Default Network ACL for VPC created
################################################################################

# # Not enabled since its covered by the aws_vpc output already
# output "default_network_acl_id" {
#   description = "ID of the Default Network ACL"
#   value       = try(aws_default_network_acl.this[0].id, null)
# }

output "default_network_acl_arn" {
  description = "ARN of the Default Network ACL"
  value       = try(aws_default_network_acl.this[0].arn, null)
}


################################################################################
# Default Route Table for VPC created
################################################################################

# # Not enabled since its covered by the aws_vpc output already
# output "default_route_table_id" {
#   description = "ID of the default route table"
#   value       = try(aws_default_route_table.this[0].id, null)
# }

output "default_route_table_arn" {
  description = "ARN of the default route table"
  value       = try(aws_default_route_table.this[0].arn, null)
}

################################################################################
# Default DHCP Options
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

output "default_vpc_cidr_block" {
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
