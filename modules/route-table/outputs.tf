################################################################################
# Route Table
################################################################################

output "id" {
  description = "The ID of the routing table"
  value       = try(aws_route_table.this[0].id, null)
}

output "arn" {
  description = "The ARN of the route table"
  value       = try(aws_route_table.this[0].arn, null)
}

output "owner_id" {
  description = "The ID of the AWS account that owns the route table"
  value       = try(aws_route_table.this[0].owner_id, null)
}

################################################################################
# Routes
################################################################################

output "routes" {
  description = "Map of routes created and their attributes"
  value       = aws_route.this
}

################################################################################
# Route Table Association
# See `subnets` sub-module for associating to subnet
################################################################################

output "route_table_gateway_association_ids" {
  description = "List of route table gateway association IDs"
  value       = [for association in aws_route_table_association.gateway : association.id]
}
