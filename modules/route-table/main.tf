################################################################################
# Route Table
################################################################################

resource "aws_route_table" "this" {
  count = var.create ? 1 : 0

  vpc_id = var.vpc_id

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  tags = merge(var.tags, { Name = var.name })
}

################################################################################
# Routes
################################################################################

resource "aws_route" "this" {
  for_each = { for k, v in var.routes : k => v if var.create }

  route_table_id = aws_route_table.this[0].id

  destination_cidr_block      = try(each.value.destination_ipv4_cidr_block, null)
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
    create = try(each.value.timeouts.create, var.route_timeouts.create, null)
    update = try(each.value.timeouts.update, var.route_timeouts.update, null)
    delete = try(each.value.timeouts.delete, var.route_timeouts.delete, null)
  }
}

################################################################################
# Route Table Association
# See `subnets` sub-module for associating to subnet
################################################################################

resource "aws_route_table_association" "gateway" {
  for_each = { for k, v in toset(var.associated_gateway_ids) : k => v if var.create }

  gateway_id     = each.value
  route_table_id = aws_route_table.this[0].id
}
