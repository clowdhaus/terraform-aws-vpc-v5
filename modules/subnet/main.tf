################################################################################
# Subnet
################################################################################

resource "aws_subnet" "this" {
  count = var.create ? 1 : 0

  assign_ipv6_address_on_creation                = var.assign_ipv6_address_on_creation
  availability_zone                              = var.availability_zone
  availability_zone_id                           = var.availability_zone_id
  cidr_block                                     = var.ipv4_cidr_block
  customer_owned_ipv4_pool                       = var.customer_owned_ipv4_pool
  enable_dns64                                   = var.enable_dns64
  enable_lni_at_device_index                     = var.enable_lni_at_device_index
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_resource_name_dns_aaaa_record_on_launch
  enable_resource_name_dns_a_record_on_launch    = var.enable_resource_name_dns_a_record_on_launch
  ipv6_cidr_block                                = var.ipv6_cidr_block
  ipv6_native                                    = var.ipv6_native
  map_customer_owned_ip_on_launch                = var.map_customer_owned_ip_on_launch
  map_public_ip_on_launch                        = var.map_public_ip_on_launch
  outpost_arn                                    = var.outpost_arn
  private_dns_hostname_type_on_launch            = var.private_dns_hostname_type_on_launch
  vpc_id                                         = var.vpc_id

  timeouts {
    create = try(var.timeouts.create, null)
    delete = try(var.timeouts.delete, null)
  }

  tags = merge(
    var.tags,
    { Name = var.name },
  )
}

################################################################################
# EC2 Subnet CIDR Reservation
################################################################################

resource "aws_ec2_subnet_cidr_reservation" "this" {
  for_each = { for k, v in var.cidr_reservations : k => v if var.create }

  cidr_block       = each.value.cidr_block
  description      = try(each.value.description, null)
  reservation_type = each.value.reservation_type
  subnet_id        = aws_subnet.this[0].id
}

################################################################################
# RAM Resource Association
################################################################################

resource "aws_ram_resource_association" "this" {
  count = var.create && var.share_subnet ? 1 : 0

  resource_arn       = aws_subnet.this[0].arn
  resource_share_arn = var.resource_share_arn
}

################################################################################
# Route Table
################################################################################

resource "aws_route_table" "this" {
  count = var.create && var.create_route_table ? 1 : 0

  propagating_vgws = var.route_table_propagating_vgws
  vpc_id           = var.vpc_id

  timeouts {
    create = try(var.route_table_timeouts.create, null)
    update = try(var.route_table_timeouts.update, null)
    delete = try(var.route_table_timeouts.delete, null)
  }

  tags = merge(
    var.tags,
    { Name = var.name },
    var.route_table_tags,
  )
}

################################################################################
# Routes
################################################################################

resource "aws_route" "this" {
  for_each = { for k, v in var.routes : k => v if var.create && var.create_route_table }

  destination_cidr_block      = try(each.value.destination_ipv4_cidr_block, null)
  destination_ipv6_cidr_block = try(each.value.destination_ipv6_cidr_block, null)
  destination_prefix_list_id  = try(each.value.destination_prefix_list_id, null)

  # One of the following target arguments must be supplied:
  carrier_gateway_id        = try(each.value.carrier_gateway_id, null)
  egress_only_gateway_id    = try(each.value.egress_only_gateway_id, null)
  gateway_id                = try(each.value.gateway_id, null)
  local_gateway_id          = try(each.value.local_gateway_id, null)
  nat_gateway_id            = try(each.value.nat_gateway_id, null)
  network_interface_id      = try(each.value.network_interface_id, null)
  route_table_id            = aws_route_table.this[0].id
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
################################################################################

resource "aws_route_table_association" "gateway" {
  for_each = { for k, v in var.associated_gateways : k => v if var.create && var.create_route_table }

  gateway_id     = each.value.id
  route_table_id = aws_route_table.this[0].id

  timeouts {
    create = try(each.value.timeouts.create, var.route_table_association_timeouts.create, null)
    update = try(each.value.timeouts.update, var.route_table_association_timeouts.update, null)
    delete = try(each.value.timeouts.delete, var.route_table_association_timeouts.delete, null)
  }
}

resource "aws_route_table_association" "subnet" {
  count = var.create ? 1 : 0

  subnet_id      = aws_subnet.this[0].id
  route_table_id = var.create_route_table ? aws_route_table.this[0].id : var.route_table_id

  timeouts {
    create = try(var.route_table_association_timeouts.create, null)
    update = try(var.route_table_association_timeouts.update, null)
    delete = try(var.route_table_association_timeouts.delete, null)
  }
}

################################################################################
# NAT Gateway
################################################################################

resource "aws_eip" "this" {
  count = var.create && var.create_nat_gateway && var.create_eip ? 1 : 0

  address                   = var.eip_address
  associate_with_private_ip = var.eip_associate_with_private_ip
  customer_owned_ipv4_pool  = var.eip_customer_owned_ipv4_pool
  domain                    = "vpc"
  network_border_group      = var.eip_network_border_group
  public_ipv4_pool          = var.eip_public_ipv4_pool

  tags = merge(
    var.tags,
    { Name = var.name },
  )

  depends_on = [
    aws_internet_gateway.this
  ]
}

resource "aws_nat_gateway" "this" {
  count = var.create && var.create_nat_gateway ? 1 : 0

  allocation_id     = var.create_eip ? aws_eip.this[0].id : var.nat_gateway_allocation_id
  connectivity_type = var.nat_gateway_connectivity_type
  subnet_id         = aws_subnet.this[0].id

  tags = merge(
    var.tags,
    { Name = var.name },
    var.nat_gateway_tags,
  )
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  count = var.create && var.create_internet_gateway ? 1 : 0

  tags = merge(
    var.tags,
    { Name = var.name },
    var.internet_gateway_tags,
  )
}

resource "aws_internet_gateway_attachment" "this" {
  count = var.create && var.attach_internet_gateway ? 1 : 0

  vpc_id              = var.vpc_id
  internet_gateway_id = var.create_internet_gateway ? aws_internet_gateway.this[0].id : var.internet_gateway_id
}

resource "aws_egress_only_internet_gateway" "this" {
  count = var.create && var.create_egress_only_internet_gateway ? 1 : 0

  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    { Name = var.name },
    var.internet_gateway_tags,
  )
}
