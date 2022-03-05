################################################################################
# Subnet
################################################################################

output "subnets" {
  description = "Map of subnets created and their attributes"
  value       = aws_subnet.this
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
# Network ACL
################################################################################

output "network_acls" {
  description = "Map of network ACLs created and their attributes"
  value       = aws_network_acl.this
}

output "network_acl_rules" {
  description = "Map of network ACL rules created and their attributes"
  value       = aws_network_acl_rule.this
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
