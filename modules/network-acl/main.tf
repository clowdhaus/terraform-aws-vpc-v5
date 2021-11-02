################################################################################
# Network ACL
################################################################################

resource "aws_network_acl" "this" {
  for_each = var.create ? var.network_acls : {}

  vpc_id     = var.vpc_id
  subnet_ids = lookup(each.value, "subnet_ids", null)

  tags = merge(
    { "Name" = lookup(each.value, "name", "${var.name}-${each.key}") },
    var.tags,
    lookup(each.value, "tags", {})
  )
}

################################################################################
# Network ACL Rule(s)
################################################################################

resource "aws_network_acl_rule" "this" {
  for_each = var.create ? var.network_acl_rules : {}

  network_acl_id = aws_network_acl.this[each.value.network_acl_key].id

  rule_number     = each.value.rule_number
  egress          = lookup(each.value, "egress", null)
  protocol        = each.value.protocol
  rule_action     = each.value.rule_action
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}
