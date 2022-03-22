################################################################################
# Firewall Rule Group
################################################################################

resource "aws_route53_resolver_firewall_rule_group" "this" {
  count = var.create ? 1 : 0

  name = var.name
  tags = var.tags
}

################################################################################
# RAM Resource Association
################################################################################

resource "aws_ram_resource_association" "this" {
  for_each = { for k, v in var.ram_resource_associations : k => v if var.create }

  resource_arn       = aws_route53_resolver_firewall_rule_group.this[0].arn
  resource_share_arn = each.value.resource_share_arn
}

################################################################################
# Firewall Domain List
################################################################################

resource "aws_route53_resolver_firewall_domain_list" "this" {
  # Because there is a 1:1 relationship between domain list and rule group
  # assocaition, we have defined them under one map definition
  for_each = { for k, v in var.rules : k => v if var.create }

  name    = try(each.value.name, each.key)
  domains = each.value.domains

  tags = merge(var.tags, try(each.value.tags, {}))
}

################################################################################
# Firewall Rule
################################################################################

resource "aws_route53_resolver_firewall_rule" "this" {
  for_each = { for k, v in var.rules : k => v if var.create }

  name                    = try(each.value.name, each.key)
  priority                = each.value.priority
  action                  = each.value.action
  block_response          = try(each.value.block_response, null)
  block_override_dns_type = try(each.value.block_override_dns_type, null)
  block_override_domain   = try(each.value.block_override_domain, null)
  block_override_ttl      = try(each.value.block_override_ttl, null)
  firewall_domain_list_id = try(each.value.domain_list_id, aws_route53_resolver_firewall_domain_list.this[each.key].id)
  firewall_rule_group_id  = aws_route53_resolver_firewall_rule_group.this[0].id
}
