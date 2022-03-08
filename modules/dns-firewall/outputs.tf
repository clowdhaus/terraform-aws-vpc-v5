################################################################################
# Firewall Config
################################################################################

output "config_id" {
  description = "The ID of the firewall configuration"
  value       = try(aws_route53_resolver_firewall_config.this[0].id, null)
}

################################################################################
# Firewall Domain List
################################################################################

output "domain_lists" {
  description = "Map of all domain lists created and their attributes"
  value       = aws_route53_resolver_firewall_domain_list.this
}

################################################################################
# Firewall Rule Group
################################################################################

output "rule_group_arn" {
  description = "The ARN (Amazon Resource Name) of the rule group"
  value       = try(aws_route53_resolver_firewall_rule_group.this[0].arn, null)
}

output "rule_group_id" {
  description = "The ID of the rule group"
  value       = try(aws_route53_resolver_firewall_rule_group.this[0].id, null)
}

output "rule_group_share_status" {
  description = "Whether the rule group is shared with other AWS accounts, or was shared with the current account by another AWS account. Sharing is configured through AWS Resource Access Manager (AWS RAM). Valid values: `NOT_SHARED`, `SHARED_BY_ME`, `SHARED_WITH_ME`"
  value       = try(aws_route53_resolver_firewall_rule_group.this[0].share_status, null)
}

################################################################################
# Firewall Rule
################################################################################

output "rules" {
  description = "Map of all rules created and their attributes"
  value       = aws_route53_resolver_firewall_rule.this
}

################################################################################
# Firewall Rule Group Association
################################################################################

output "rule_group_association_arn" {
  description = "The ARN (Amazon Resource Name) of the rule group association"
  value       = try(aws_route53_resolver_firewall_rule_group_association.this[0].arn, null)
}

output "rule_group_association_id" {
  description = "The ID of the rule group association"
  value       = try(aws_route53_resolver_firewall_rule_group_association.this[0].id, null)
}
