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

  cidr_block               = try(each.value.cidr_block, null)
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
    { Name = "${var.name}-${each.key}" },
    try(each.value.tags, {})
  )
}

################################################################################
# EC2 Subnet CIDR Reservation
################################################################################

resource "aws_ec2_subnet_cidr_reservation" "this" {
  # Ugly, but it works as intended - TODO: make it less ugly
  for_each = element(values({
    for k, v in var.subnets : k => {
      # Add subnet map key into CIDR reservation map so we can flatten nested maps with `values()`
      for k2, v2 in v.ec2_subnet_cidr_reservations : k2 => merge({ subnet_key = k }, v2)
    } if var.create && can(v.ec2_subnet_cidr_reservations)
  }), 0)

  description      = try(each.value.description, null)
  cidr_block       = each.value.cidr_block
  reservation_type = each.value.reservation_type
  subnet_id        = aws_subnet.this[each.value.subnet_key].id
}

################################################################################
# Route Table / Routes
################################################################################

locals {
  # We have to change:
  # my_shared_route_table = {
  #    associated_subnet_keys = ["subnet_key_1", "subnet_key_2"]
  #  }
  # Into:
  # {
  #   "subnet_key_1" = "my_shared_route_table"
  #   "subnet_key_2" = "my_shared_route_table"
  # }
  subnet_route_table_associations = [for k, v in var.route_tables : zipmap(lookup(v, "associated_subnet_keys", []), [for i in range(length(lookup(v, "associated_subnet_keys", []))) : k])]
  # Same approach as subnets above
  gateway_route_table_associations = [for k, v in var.route_tables : zipmap(lookup(v, "associated_gateway_ids", []), [for i in range(length(lookup(v, "associated_gateway_ids", []))) : k])]

  routes = element(values({
    for k, v in var.route_tables : k => {
      for k2, v2 in try(v.routes, {}) : k2 => merge({ route_table_key = k }, v2)
    }
  }), 0)
}

resource "aws_route_table" "this" {
  for_each = { for k, v in var.route_tables : k => v if var.create }

  vpc_id = var.vpc_id

  timeouts {
    create = try(var.route_table_timeouts.create, null)
    update = try(var.route_table_timeouts.update, null)
    delete = try(var.route_table_timeouts.delete, null)
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}" },
    try(each.value.tags, {})
  )
}

resource "aws_route_table_association" "subnet" {
  for_each = { for k, v in element(local.subnet_route_table_associations, 0) : k => v if var.create }

  subnet_id      = try(aws_subnet.this[each.key].id, null)
  route_table_id = aws_route_table.this[each.value].id
}

resource "aws_route_table_association" "gateway" {
  for_each = { for k, v in element(local.gateway_route_table_associations, 0) : k => v if var.create }

  gateway_id     = each.key
  route_table_id = aws_route_table.this[each.value].id
}

resource "aws_route" "this" {
  for_each = { for k, v in local.routes : k => v if var.create }

  route_table_id = aws_route_table.this[each.value.route_table_key].id

  # One of the following destination arguments must be supplied:
  destination_cidr_block      = try(each.value.destination_cidr_block, null)
  destination_ipv6_cidr_block = try(each.value.destination_ipv6_cidr_block, null)
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

  timeouts {
    create = try(var.route_timeouts.create, null)
    update = try(var.route_timeouts.update, null)
    delete = try(var.route_timeouts.delete, null)
  }
}

################################################################################
# Network ACL
################################################################################

resource "aws_network_acl" "this" {
  count = var.create && var.create_network_acl ? 1 : 0

  vpc_id     = var.vpc_id
  subnet_ids = [for subnet in aws_subnet.this : subnet.id]

  tags = merge(
    var.tags,
    { Name = var.name },
    try(var.network_acl_tags, {})
  )
}

resource "aws_network_acl_rule" "this" {
  for_each = { for k, v in var.network_acl_rules : k => v if var.create && var.create_network_acl }

  network_acl_id = aws_network_acl.this[0].id

  rule_number     = each.key
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

################################################################################
# NAT Gateway
################################################################################

resource "aws_eip" "this" {
  for_each = { for k, v in var.subnets : k => v if var.create && try(v.create_nat_gateway, false) && !can(v.allocation_id) }

  address                   = try(each.value.address, null)
  associate_with_private_ip = try(each.value.associate_with_private_ip, null)
  customer_owned_ipv4_pool  = try(each.value.customer_owned_ipv4_pool, null)
  network_border_group      = try(each.value.network_border_group, null)
  public_ipv4_pool          = try(each.value.public_ipv4_pool, null)
  vpc                       = true

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}" },
    try(each.value.tags, {})
  )
}

resource "aws_nat_gateway" "this" {
  for_each = { for k, v in var.subnets : k => v if var.create && try(v.create_nat_gateway, false) }

  allocation_id     = try(each.value.allocation_id, aws_eip.this[each.key].id, null)
  connectivity_type = try(each.value.connectivity_type, null)
  subnet_id         = aws_subnet.this[each.key].id

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}" },
    try(each.value.tags, {})
  )
}
