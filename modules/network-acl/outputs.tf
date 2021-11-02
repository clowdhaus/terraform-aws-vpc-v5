output "network_acls" {
  description = "Map of network ACLs created and their attributes"
  value       = aws_network_acl.this
}

output "network_acl_rules" {
  description = "Map of network ACL rules created and their attributes"
  value       = aws_network_acl_rule.this
}
