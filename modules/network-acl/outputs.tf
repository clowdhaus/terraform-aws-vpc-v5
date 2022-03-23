################################################################################
# Network ACL
################################################################################

output "arn" {
  description = "The ID of the network ACL"
  value       = try(aws_network_acl.this[0].arn, null)
}

output "id" {
  description = "The ARN of the network ACL"
  value       = try(aws_network_acl.this[0].id, null)
}

output "rules_ingress" {
  description = "Map of ingress network ACL rules created and their attributes"
  value       = aws_network_acl_rule.ingress
}

output "rules_egress" {
  description = "Map of egress network ACL rules created and their attributes"
  value       = aws_network_acl_rule.egress
}
