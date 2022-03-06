################################################################################
# Subnet
################################################################################

output "subnets" {
  description = "Map of subnets created and their attributes"
  value       = aws_subnet.this
}

output "subnet_arns" {
  description = "List of subnet ARNs"
  value       = [for subnet in aws_subnet.this : subnet.arn]
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = [for subnet in aws_subnet.this : subnet.id]
}

output "subnet_ipv4_cidr_blocks" {
  description = "List of subnet IPv4 CIDR blocks"
  value       = compact([for subnet in aws_subnet.this : subnet.cidr_block])
}

output "subnet_ipv6_cidr_blocks" {
  description = "List of subnet IPv6 CIDR blocks"
  value       = compact([for subnet in aws_subnet.this : subnet.ipv6_cidr_block])
}

################################################################################
# EC2 Subnet CIDR Reservation
################################################################################

output "ec2_subnet_cidr_reservations" {
  description = "Map of EC2 subnet CIDR reservations created and their attributes"
  value       = aws_ec2_subnet_cidr_reservation.this
}

################################################################################
# Route Table
################################################################################

output "route_tables" {
  description = "Map of route tables created and their attributes"
  value       = aws_route_table.this
}

output "route_table_ids" {
  description = "List of route table IDs"
  value       = [for table in aws_route_table.this : table.id]
}

output "routes" {
  description = "Map of routes created and their attributes"
  value       = aws_route.this
}

output "route_ids" {
  description = "List of route IDs"
  value       = [for route in aws_route.this : route.id]
}

output "route_table_subnet_association_ids" {
  description = "List of subnet route table association IDs"
  value       = [for association in aws_route_table_association.subnet : association.id]
}

output "route_table_gateway_association_ids" {
  description = "List of gateway route table association IDs"
  value       = [for association in aws_route_table_association.gateway : association.id]
}

################################################################################
# Network ACL
################################################################################

output "network_acl_arn" {
  description = "The ID of the network ACL"
  value       = try(aws_network_acl.this[0].arn, null)
}

output "network_acl_id" {
  description = "The ARN of the network ACL"
  value       = try(aws_network_acl.this[0].id, null)
}

output "network_acl_rules_ingress" {
  description = "Map of ingress network ACL rules created and their attributes"
  value       = aws_network_acl_rule.ingress
}

output "network_acl_rules_egress" {
  description = "Map of egress network ACL rules created and their attributes"
  value       = aws_network_acl_rule.egress
}
