locals {
  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = try(aws_vpc_ipv4_cidr_block_association.this[0].vpc_id, aws_vpc.this[0].id, "")

}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  count = var.create ? 1 : 0

  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.vpc_tags,
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  for_each = var.create ? toset(var.secondary_cidr_blocks) : []

  vpc_id     = aws_vpc.this[0].id
  cidr_block = each.value
}

################################################################################
# DHCP Options Set
################################################################################

resource "aws_vpc_dhcp_options" "this" {
  count = var.create && var.create_dhcp_options ? 1 : 0

  domain_name          = var.dhcp_options_domain_name
  domain_name_servers  = var.dhcp_options_domain_name_servers
  ntp_servers          = var.dhcp_options_ntp_servers
  netbios_name_servers = var.dhcp_options_netbios_name_servers
  netbios_node_type    = var.dhcp_options_netbios_node_type

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.dhcp_options_tags,
  )
}

resource "aws_vpc_dhcp_options_association" "this" {
  count = var.create && var.create_dhcp_options ? 1 : 0

  vpc_id          = local.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}

################################################################################
# Route Table
################################################################################

resource "aws_route_table" "this" {
  for_each = var.create ? var.route_tables : {}

  vpc_id = local.vpc_id

  dynamic "timeouts" {
    for_each = var.route_table_timeouts
    content {
      create = lookup(each.value, "create", null)
      update = lookup(each.value, "update", null)
      delete = lookup(each.value, "delete", null)
    }
  }

  tags = merge(
    { "Name" = lookup(each.value, "name", "${var.name}-${each.key}") },
    var.tags,
    lookup(each.value, "tags", {})
  )
}

resource "aws_route_table_association" "this" {
  for_each = var.create ? var.subnets : {}

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.this[each.value.route_table_key].id
}

resource "aws_route" "this" {
  for_each = var.create ? var.routes : {}

  route_table_id = aws_route_table.this[each.value.route_table_key].id

  # One of the following destination arguments must be supplied:
  destination_cidr_block      = lookup(each.value, "cidr_block", null)
  destination_ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  destination_prefix_list_id  = lookup(each.value, "destination_prefix_list_id", null)

  # One of the following target arguments must be supplied:
  carrier_gateway_id        = lookup(each.value, "carrier_gateway_id", null)
  egress_only_gateway_id    = lookup(each.value, "egress_only_gateway_id", null)
  gateway_id                = lookup(each.value, "gateway_id", null)
  instance_id               = lookup(each.value, "instance_id", null)
  nat_gateway_id            = lookup(each.value, "nat_gateway_id", null)
  local_gateway_id          = lookup(each.value, "local_gateway_id", null)
  network_interface_id      = lookup(each.value, "network_interface_id", null)
  transit_gateway_id        = lookup(each.value, "transit_gateway_id", null)
  vpc_endpoint_id           = lookup(each.value, "vpc_endpoint_id", null)
  vpc_peering_connection_id = lookup(each.value, "vpc_peering_connection_id", null)
}

################################################################################
# Subnet
################################################################################

resource "aws_subnet" "this" {
  for_each = var.create ? var.subnets : {}

  vpc_id = local.vpc_id

  availability_zone               = lookup(each.value, "availability_zone", null)
  availability_zone_id            = lookup(each.value, "availability_zone_id", null)
  cidr_block                      = each.value.cidr_block
  customer_owned_ipv4_pool        = lookup(each.value, "customer_owned_ipv4_pool", null)
  ipv6_cidr_block                 = lookup(each.value, "ipv6_cidr_block", null)
  map_customer_owned_ip_on_launch = lookup(each.value, "map_customer_owned_ip_on_launch", null)
  map_public_ip_on_launch         = lookup(each.value, "map_public_ip_on_launch", null)
  outpost_arn                     = lookup(each.value, "outpost_arn", null)
  assign_ipv6_address_on_creation = lookup(each.value, "assign_ipv6_address_on_creation", null)

  dynamic "timeouts" {
    for_each = var.subnet_timeouts
    content {
      create = lookup(each.value, "create", null)
      delete = lookup(each.value, "delete", null)
    }
  }

  tags = merge(
    { "Name" = lookup(each.value, "name", "${var.name}-${each.key}") },
    var.tags,
    lookup(each.value, "tags", {})
  )
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  count = var.create && var.create_igw ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.igw_tags,
  )
}

resource "aws_route" "internet_gateway" {
  for_each = var.create && var.create_igw ? var.igw_routes : {}

  route_table_id         = aws_route_table.this[each.value.route_table_key].id
  destination_cidr_block = lookup(each.value, "destination_cidr_block", "0.0.0.0/0")
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_egress_only_internet_gateway" "this" {
  count = var.create && var.create_egress_only_igw ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = var.name },
    var.tags,
    var.igw_tags,
  )
}

resource "aws_route" "egress_only_internet_gateway" {
  for_each = var.create && var.create_egress_only_igw ? var.egress_only_igw_routes : {}

  route_table_id              = aws_route_table.this[each.value.route_table_key].id
  destination_ipv6_cidr_block = lookup(each.value, "destination_ipv6_cidr_block", "::/0")
  gateway_id                  = aws_egress_only_internet_gateway.this[0].id
}

################################################################################
# Network ACL
################################################################################

resource "aws_network_acl" "this" {
  for_each = var.create ? var.network_acls : {}

  vpc_id     = local.vpc_id
  subnet_ids = distinct([for k in each.value.subnet_keys : aws_subnet.this[k].id])

  tags = merge(
    { "Name" = lookup(each.value, "name", "${var.name}-${each.key}") },
    var.tags,
    lookup(each.value, "tags", {})
  )
}

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
