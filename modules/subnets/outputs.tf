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
  value       = aws_route.this
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
