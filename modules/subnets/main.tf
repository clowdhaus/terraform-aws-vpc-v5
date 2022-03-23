################################################################################
# Subnet
################################################################################

resource "aws_subnet" "this" {
  for_each = { for k, v in var.subnets : k => v if var.create }

  vpc_id = var.vpc_id

  availability_zone                   = try(var.subnets_default.availability_zone, each.value.availability_zone, null)
  availability_zone_id                = try(var.subnets_default.availability_zone_id, each.value.availability_zone_id, null)
  map_customer_owned_ip_on_launch     = try(var.subnets_default.map_customer_owned_ip_on_launch, each.value.map_customer_owned_ip_on_launch, null)
  map_public_ip_on_launch             = try(var.subnets_default.map_public_ip_on_launch, each.value.map_public_ip_on_launch, null)
  private_dns_hostname_type_on_launch = try(var.subnets_default.private_dns_hostname_type_on_launch, each.value.private_dns_hostname_type_on_launch, null)

  cidr_block               = try(each.value.ipv4_cidr_block, null)
  customer_owned_ipv4_pool = try(var.subnets_default.customer_owned_ipv4_pool, each.value.customer_owned_ipv4_pool, null)

  ipv6_cidr_block                 = try(each.value.ipv6_cidr_block, null)
  ipv6_native                     = try(var.subnets_default.ipv6_native, each.value.ipv6_native, null)
  assign_ipv6_address_on_creation = try(var.subnets_default.assign_ipv6_address_on_creation, each.value.assign_ipv6_address_on_creation, null)

  enable_dns64                                   = try(var.subnets_default.enable_dns64, each.value.enable_dns64, null)
  enable_resource_name_dns_a_record_on_launch    = try(var.subnets_default.enable_resource_name_dns_a_record_on_launch, each.value.enable_resource_name_dns_a_record_on_launch, null)
  enable_resource_name_dns_aaaa_record_on_launch = try(var.subnets_default.enable_resource_name_dns_aaaa_record_on_launch, each.value.enable_resource_name_dns_aaaa_record_on_launch, null)

  outpost_arn = try(var.subnets_default.outpost_arn, each.value.outpost_arn, null)

  timeouts {
    create = try(var.subnet_timeouts.create, null)
    delete = try(var.subnet_timeouts.delete, null)
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}" },
    try(var.subnets_default.tags, {}),
    try(each.value.tags, {})
  )
}

################################################################################
# EC2 Subnet CIDR Reservation
################################################################################

resource "aws_ec2_subnet_cidr_reservation" "this" {
  for_each = { for k, v in var.cidr_reservations : k => v if var.create }

  description = try(each.value.description, null)
  # TODO - is this IPv4 only or does IPv6 work as well?
  cidr_block       = each.value.cidr_block
  reservation_type = each.value.reservation_type
  subnet_id        = aws_subnet.this[each.value.subnet_key].id
}

################################################################################
# RAM Resource Association
################################################################################

resource "aws_ram_resource_association" "this" {
  for_each = { for k, v in var.subnets : k => v if var.create && can(v.resource_share_arn) }

  resource_arn       = aws_subnet.this[each.key].arn
  resource_share_arn = each.value.resource_share_arn
}

################################################################################
# Route Table Association
# See `route` sub-module for associating to gateway
################################################################################

resource "aws_route_table_association" "this" {
  for_each = { for k, v in var.subnets : k => v if var.create }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = try(var.subnets_default.route_table_id, each.value.route_table_id, null)
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
