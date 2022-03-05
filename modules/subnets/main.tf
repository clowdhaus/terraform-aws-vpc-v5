################################################################################
# Subnet
################################################################################

resource "aws_subnet" "this" {
  for_each = { for k, v in var.subnets : k => v if var.create }

  vpc_id = var.vpc_id

  availability_zone                   = try(each.value.availability_zone, null)
  availability_zone_id                = try(each.value.availability_zone_id, null)
  map_customer_owned_ip_on_launch     = try(each.value.map_customer_owned_ip_on_launch, null)
  map_public_ip_on_launch             = try(each.value.map_public_ip_on_launch, null)
  private_dns_hostname_type_on_launch = try(each.value.private_dns_hostname_type_on_launch, null)

  cidr_block               = each.value.cidr_block
  customer_owned_ipv4_pool = try(each.value.customer_owned_ipv4_pool, null)

  ipv6_cidr_block                 = try(each.value.ipv6_cidr_block, null)
  ipv6_native                     = try(each.value.ipv6_native, null)
  assign_ipv6_address_on_creation = try(each.value.assign_ipv6_address_on_creation, null)

  enable_dns64                                   = try(each.value.enable_dns64, null)
  enable_resource_name_dns_a_record_on_launch    = try(each.value.enable_resource_name_dns_a_record_on_launch, null)
  enable_resource_name_dns_aaaa_record_on_launch = try(each.value.enable_resource_name_dns_aaaa_record_on_launch, null)

  outpost_arn = try(each.value.outpost_arn, null)

  timeouts {
    create = try(var.subnet_timeouts.create, null)
    delete = try(var.subnet_timeouts.delete, null)
  }

  tags = merge(
    var.tags,
    { Name = try(each.value.name, "${var.name}-${each.key}") },
    try(each.value.tags, {})
  )
}

################################################################################
# Route Table
################################################################################

resource "aws_route_table" "this" {
  for_each = { for k, v in var.route_tables : k => v if var.create }

  vpc_id = var.vpc_id

  dynamic "timeouts" {
    for_each = var.route_table_timeouts
    content {
      create = try(each.value.create, null)
      update = try(each.value.update, null)
      delete = try(each.value.delete, null)
    }
  }

  tags = merge(
    var.tags,
    { "Name" = try(each.value.name, "${var.name}-${each.key}") },
    try(each.value.tags, {})
  )
}

# resource "aws_route_table_association" "this" {
#   for_each = { for k, v in var.subnets : k => v if var.create }

#   subnet_id = try(aws_subnet.this[each.key].id, null)
#   # gateway_id = ""
#   route_table_id = aws_route_table.this[each.value.route_table_key].id
# }

resource "aws_route" "this" {
  for_each = { for k, v in var.routes : k => v if var.create }

  route_table_id = aws_route_table.this[each.value.route_table_key].id

  # One of the following destination arguments must be supplied:
  destination_cidr_block      = try(each.value.cidr_block, null)
  destination_ipv6_cidr_block = try(each.value.ipv6_cidr_block, null)
  destination_prefix_list_id  = try(each.value.destination_prefix_list_id, null)

  # One of the following target arguments must be supplied:
  carrier_gateway_id        = try(each.value.carrier_gateway_id, null)
  egress_only_gateway_id    = try(each.value.egress_only_gateway_id, null)
  gateway_id                = try(each.value.gateway_id, null)
  nat_gateway_id            = try(each.value.nat_gateway_id, null)
  local_gateway_id          = try(each.value.local_gateway_id, null)
  network_interface_id      = try(each.value.network_interface_id, null)
  transit_gateway_id        = try(each.value.transit_gateway_id, null)
  vpc_endpoint_id           = try(each.value.vpc_endpoint_id, null)
  vpc_peering_connection_id = try(each.value.vpc_peering_connection_id, null)
}

################################################################################
# Network ACL
################################################################################

resource "aws_network_acl" "this" {
  for_each = { for k, v in var.network_acls : k => v if var.create }

  vpc_id     = var.vpc_id
  subnet_ids = try(each.value.subnet_ids, null)

  tags = merge(
    var.tags,
    { "Name" = try(each.value.name, "${var.name}-${each.key}") },
    try(each.value.tags, {})
  )
}

resource "aws_network_acl_rule" "this" {
  for_each = { for k, v in var.network_acl_rules : k => v if var.create }

  network_acl_id = aws_network_acl.this[each.value.network_acl_key].id

  rule_number     = each.value.rule_number
  egress          = try(each.value.egress, null)
  protocol        = each.value.protocol
  rule_action     = each.value.rule_action
  cidr_block      = try(each.value.cidr_block, null)
  ipv6_cidr_block = try(each.value.ipv6_cidr_block, null)
  from_port       = try(each.value.from_port, null)
  to_port         = try(each.value.to_port, null)
  icmp_type       = try(each.value.icmp_type, null)
  icmp_code       = try(each.value.icmp_code, null)
}
