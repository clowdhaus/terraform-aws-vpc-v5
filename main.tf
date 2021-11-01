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
  route  = each.value.route

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
