locals {
  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = try(aws_vpc_ipv4_cidr_block_association.this[0].vpc_id, aws_vpc.this[0].id, null)
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

  vpc_id          = aws_vpc.this[0].id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  count = var.create && var.create_internet_gateway ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    var.tags,
    { Name = var.name },
    var.internet_gateway_tags,
  )
}

resource "aws_egress_only_internet_gateway" "this" {
  count = var.create && var.create_egress_only_internet_gateway ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    var.tags,
    { Name = var.name },
    var.internet_gateway_tags,
  )
}

################################################################################
# Customer Gateway(s)
################################################################################

resource "aws_customer_gateway" "this" {
  for_each = { for k, v in var.customer_gateways : k => v if var.create }

  bgp_asn    = each.value.bgp_asn
  ip_address = each.value.ip_address
  type       = try(each.value.type, "ipsec.1") # required but only one value accepted

  certificate_arn = try(each.value.certificate_arn, null)
  device_name     = try(each.value.device_name, null)

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}" },
    var.customer_gateway_tags,
  )
}

################################################################################
# VPN Gateway(s)
################################################################################

resource "aws_vpn_gateway" "this" {
  for_each = { for k, v in var.vpn_gateways : k => v if var.create }

  vpc_id            = local.vpc_id
  amazon_side_asn   = try(each.value.vpn_gateway_amazon_side_asn, null)
  availability_zone = try(each.value.availability_zone, null)

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}" },
    var.vpn_gateway_tags,
  )
}
