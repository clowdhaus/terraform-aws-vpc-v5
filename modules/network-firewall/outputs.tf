################################################################################
# Firewall
################################################################################

output "id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall"
  value       = try(aws_networkfirewall_firewall.this[0].id, null)
}

output "arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall"
  value       = try(aws_networkfirewall_firewall.this[0].arn, null)
}

output "status" {
  description = "Nested list of information about the current status of the firewall"
  value       = try(aws_networkfirewall_firewall.this[0].firewall_status, null)
}

output "update_token" {
  description = "A string token used when updating a firewall"
  value       = try(aws_networkfirewall_firewall.this[0].update_token, null)
}

################################################################################
# Firewall Policy
################################################################################

output "policy_id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy"
  value       = try(aws_networkfirewall_firewall_policy.this[0].id, null)
}

output "policy_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy"
  value       = try(aws_networkfirewall_firewall_policy.this[0].arn, null)
}

output "policy_update_token" {
  description = "A string token used when updating a firewall policy"
  value       = try(aws_networkfirewall_firewall_policy.this[0].update_token, null)
}

################################################################################
# Firewall Rule Group
################################################################################

output "rule_groups" {
  description = "A map of the rule groups created and their attributes"
  value       = aws_networkfirewall_rule_group.this
}

################################################################################
# Firewall Resource Policy
################################################################################

output "firewall_policy_resource_policy_id" {
  description = "The Amazon Resource Name (ARN) of the firewall policy associated with the resource policy"
  value       = try(aws_networkfirewall_resource_policy.firewall_policy[0].id, null)
}

output "rule_group_resource_policies" {
  description = "Map of Rule Group resource policies created and their attributes"
  value       = aws_networkfirewall_resource_policy.rule_group
}
