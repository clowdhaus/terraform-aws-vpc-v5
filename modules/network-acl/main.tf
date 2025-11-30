################################################################################
# Network ACL
################################################################################

resource "aws_network_acl" "this" {
  count = var.create ? 1 : 0

  region = var.region

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_network_acl_rule" "ingress" {
  for_each = { for k, v in var.ingress_rules : k => v if var.create }

  region = var.region

  network_acl_id = aws_network_acl.this[0].id

  rule_number     = each.key
  egress          = false
  protocol        = each.value.protocol
  rule_action     = each.value.rule_action
  cidr_block      = try(each.value.ipv4_cidr_block, null)
  ipv6_cidr_block = try(each.value.ipv6_cidr_block, null)
  from_port       = try(each.value.from_port, null)
  to_port         = try(each.value.to_port, null)
  icmp_type       = try(each.value.icmp_type, null)
  icmp_code       = try(each.value.icmp_code, null)
}

resource "aws_network_acl_rule" "egress" {
  for_each = { for k, v in var.egress_rules : k => v if var.create }

  region = var.region

  network_acl_id = aws_network_acl.this[0].id

  rule_number     = each.key
  egress          = true
  protocol        = each.value.protocol
  rule_action     = each.value.rule_action
  cidr_block      = try(each.value.ipv4_cidr_block, null)
  ipv6_cidr_block = try(each.value.ipv6_cidr_block, null)
  from_port       = try(each.value.from_port, null)
  to_port         = try(each.value.to_port, null)
  icmp_type       = try(each.value.icmp_type, null)
  icmp_code       = try(each.value.icmp_code, null)
}
