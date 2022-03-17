################################################################################
# Subnet
################################################################################

output "subnets" {
  description = "Map of subnets created and their attributes"
  value       = aws_subnet.this
}

output "arns" {
  description = "List of subnet ARNs"
  value       = [for subnet in aws_subnet.this : subnet.arn]
}

output "ids" {
  description = "List of subnet IDs"
  value       = [for subnet in aws_subnet.this : subnet.id]
}

output "ipv4_cidr_blocks" {
  description = "List of subnet IPv4 CIDR blocks"
  value       = compact([for subnet in aws_subnet.this : subnet.cidr_block])
}

output "ipv6_cidr_blocks" {
  description = "List of subnet IPv6 CIDR blocks"
  value       = compact([for subnet in aws_subnet.this : subnet.ipv6_cidr_block])
}

################################################################################
# Subnet Groups
################################################################################

output "dms_replication_subnet_groups" {
  description = "Map of DMS Replication subnet groups created and their attributes"
  value       = aws_dms_replication_subnet_group.this
}

output "docdb_subnet_groups" {
  description = "Map of DocumentDB subnet groups created and their attributes"
  value       = aws_docdb_subnet_group.this
}

output "dax_subnet_groups" {
  description = "Map of DAX subnet groups created and their attributes"
  value       = aws_dax_subnet_group.this
}

output "elasticache_subnet_groups" {
  description = "Map of Elasitcache subnet groups created and their attributes"
  value       = aws_elasticache_subnet_group.this
}

output "memorydb_subnet_groups" {
  description = "Map of MemoryDB subnet groups created and their attributes"
  value       = aws_memorydb_subnet_group.this
}

output "neptune_subnet_groups" {
  description = "Map of Neptune subnet groups created and their attributes"
  value       = aws_neptune_subnet_group.this
}

output "rds_subnet_groups" {
  description = "Map of RDS Database subnet groups created and their attributes"
  value       = aws_db_subnet_group.this
}

output "redshift_subnet_groups" {
  description = "Map of DMS Replication subnet groups created and their attributes"
  value       = aws_redshift_subnet_group.this
}

################################################################################
# EC2 Subnet CIDR Reservation
################################################################################

output "ec2_subnet_cidr_reservations" {
  description = "Map of EC2 subnet CIDR reservations created and their attributes"
  value       = aws_ec2_subnet_cidr_reservation.this
}

################################################################################
# Route Table Association
# See `route` sub-module for associating to gateway
################################################################################

output "route_table_association_ids" {
  description = "List of subnet route table association IDs"
  value       = [for association in aws_route_table_association.this : association.id]
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

################################################################################
# NAT Gateway
################################################################################

output "nat_gateways" {
  description = "Map of NAT gateway(s) created and their attributes"
  value       = aws_nat_gateway.this
}

output "nat_gateway_ids" {
  description = "List of NAT gateway IDs"
  value       = [for nat in aws_nat_gateway.this : nat.id]
}

output "nat_gateway_public_ips" {
  description = "List of NAT gateway public IPs"
  value       = [for nat in aws_nat_gateway.this : nat.public_ip]
}

output "elastic_ips" {
  description = "Map of EIP(s) created and their attributes"
  value       = aws_eip.this
}
