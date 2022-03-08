################################################################################
# Firewall Config
################################################################################

resource "aws_route53_resolver_firewall_config" "this" {
  count = var.create ? 1 : 0

  resource_id        = var.vpc_id
  firewall_fail_open = var.firewall_fail_open
}

################################################################################
# Firewall Domain List
################################################################################

resource "aws_route53_resolver_firewall_domain_list" "this" {
  # Because there is a 1:1 between domain list and rule group assocaition
  # we are merging them under one map definition
  for_each = { for k, v in var.rules : k => v if var.create }

  name    = try(each.value.name, each.key)
  domains = each.value.domains

  tags = merge(var.tags, try(each.value.tags, {}))
}

################################################################################
# Firewall Rule Group
################################################################################

resource "aws_route53_resolver_firewall_rule_group" "this" {
  count = var.create ? 1 : 0

  name = var.name
  tags = var.tags
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

################################################################################
# Firewall Rule Group Association
################################################################################

resource "aws_route53_resolver_firewall_rule_group_association" "this" {
  count = var.create ? 1 : 0

  name   = var.name
  vpc_id = var.vpc_id

  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.this[0].id
  mutation_protection    = var.mutation_protection
  priority               = var.priority

  tags = var.tags
}
