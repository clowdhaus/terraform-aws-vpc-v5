locals {
  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = try(aws_vpc_ipv4_cidr_block_association.this[0].vpc_id, aws_vpc.this[0].id, "")
}

data "aws_partition" "current" {}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  count = var.create ? 1 : 0

  cidr_block          = var.cidr_block
  ipv4_ipam_pool_id   = var.ipv4_ipam_pool_id
  ipv4_netmask_length = var.ipv4_netmask_length

  ipv6_cidr_block                      = var.ipv6_cidr_block
  ipv6_ipam_pool_id                    = var.ipv6_ipam_pool_id
  ipv6_netmask_length                  = var.ipv6_netmask_length
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group
  assign_generated_ipv6_cidr_block     = var.assign_generated_ipv6_cidr_block

  instance_tenancy               = var.instance_tenancy
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support

  tags = merge(
    var.tags,
    { Name = var.name },
    var.vpc_tags,
  )
}

################################################################################
# VPC CIDR Block Association(s)
################################################################################

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  for_each = { for k, v in var.ipv4_cidr_block_associations : k => v if var.create }

  vpc_id              = aws_vpc.this[0].id
  cidr_block          = try(each.value.cidr_block, null)
  ipv4_ipam_pool_id   = try(each.value.ipv4_ipam_pool_id, null)
  ipv4_netmask_length = try(each.value.ipv4_netmask_length, null)

  timeouts {
    create = try(each.value.timeouts.create, null)
    delete = try(each.value.timeouts.delete, null)
  }
}

resource "aws_vpc_ipv6_cidr_block_association" "this" {
  for_each = { for k, v in var.ipv6_cidr_block_associations : k => v if var.create }

  vpc_id              = aws_vpc.this[0].id
  ipv6_cidr_block     = try(each.value.ipv6_cidr_block, null)
  ipv6_ipam_pool_id   = try(each.value.ipv6_ipam_pool_id, null)
  ipv6_netmask_length = try(each.value.ipv6_netmask_length, null)

  timeouts {
    create = try(each.value.timeouts.create, null)
    delete = try(each.value.timeouts.delete, null)
  }
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
    var.tags,
    { Name = var.name },
    var.dhcp_options_tags,
  )
}

resource "aws_vpc_dhcp_options_association" "this" {
  count = var.create && var.create_dhcp_options ? 1 : 0

  vpc_id          = local.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  count = var.create && var.create_igw ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    var.tags,
    { "Name" = var.name },
    var.igw_tags,
  )
}

# resource "aws_route" "internet_gateway" {
#   for_each = { for k, v in var.igw_routes : k => v if var.create && var.create_igw }

#   route_table_id         = aws_route_table.this[each.value.route_table_key].id
#   destination_cidr_block = try(each.value.destination_cidr_block, "0.0.0.0/0")
#   gateway_id             = aws_internet_gateway.this[0].id
# }

resource "aws_egress_only_internet_gateway" "this" {
  count = var.create && var.create_egress_only_igw ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    var.tags,
    { "Name" = var.name },
    var.igw_tags,
  )
}

# resource "aws_route" "egress_only_internet_gateway" {
#   for_each = var.create && var.create_egress_only_igw ? var.egress_only_igw_routes : {}

#   route_table_id              = aws_route_table.this[each.value.route_table_key].id
#   destination_ipv6_cidr_block = try(each.value.destination_ipv6_cidr_block, "::/0")
#   gateway_id                  = aws_egress_only_internet_gateway.this[0].id
# }
