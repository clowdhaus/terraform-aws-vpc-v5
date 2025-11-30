locals {
  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = try(aws_vpc_ipv4_cidr_block_association.this[0].vpc_id, aws_vpc.this[0].id, null)
}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  count = var.create ? 1 : 0

  region = var.region

  assign_generated_ipv6_cidr_block     = var.assign_generated_ipv6_cidr_block
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_dns_support                   = var.enable_dns_support
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  instance_tenancy                     = var.instance_tenancy
  cidr_block                           = var.ipv4_cidr_block
  ipv4_ipam_pool_id                    = var.ipv4_ipam_pool_id
  ipv4_netmask_length                  = var.ipv4_netmask_length
  ipv6_cidr_block                      = var.ipv6_cidr_block
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group
  ipv6_ipam_pool_id                    = var.ipv6_ipam_pool_id
  ipv6_netmask_length                  = var.ipv6_netmask_length

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
  for_each = var.create && var.ipv4_cidr_block_associations != null ? var.ipv4_cidr_block_associations : {}

  region = var.region

  cidr_block          = each.value.ipv4_cidr_block
  ipv4_ipam_pool_id   = each.value.ipv4_ipam_pool_id
  ipv4_netmask_length = each.value.ipv4_netmask_length
  vpc_id              = aws_vpc.this[0].id

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}

resource "aws_vpc_ipv6_cidr_block_association" "this" {
  for_each = var.create && var.ipv6_cidr_block_associations != null ? var.ipv6_cidr_block_associations : {}

  region = var.region

  ipv6_cidr_block     = try(each.value.ipv6_cidr_block, null)
  ipv6_ipam_pool_id   = try(each.value.ipv6_ipam_pool_id, null)
  ipv6_netmask_length = try(each.value.ipv6_netmask_length, null)
  vpc_id              = aws_vpc.this[0].id

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}

################################################################################
# VPC Block Public Access
################################################################################

resource "aws_vpc_block_public_access_exclusion" "this" {
  count = var.create && var.block_public_access_exclusion != null ? 1 : 0

  region = var.region

  internet_gateway_exclusion_mode = var.block_public_access_exclusion.internet_gateway_exclusion_mode
  vpc_id                          = local.vpc_id

  tags = var.tags
}

################################################################################
# DHCP Options Set
################################################################################

resource "aws_vpc_dhcp_options" "this" {
  count = var.create && var.dhcp_options != null ? 1 : 0

  region = var.region

  domain_name                       = var.dhcp_options.domain_name
  domain_name_servers               = var.dhcp_options.domain_name_servers
  ipv6_address_preferred_lease_time = var.dhcp_options.ipv6_address_preferred_lease_time
  netbios_name_servers              = var.dhcp_options.netbios_name_servers
  netbios_node_type                 = var.dhcp_options.netbios_node_type
  ntp_servers                       = var.dhcp_options.ntp_servers
  tags = merge(
    var.tags,
    { Name = var.name },
  )
}

resource "aws_vpc_dhcp_options_association" "this" {
  count = var.create && var.dhcp_options != null ? 1 : 0

  region = var.region

  vpc_id          = aws_vpc.this[0].id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  count = var.create && var.create_internet_gateway ? 1 : 0

  region = var.region

  tags = merge(
    var.tags,
    { Name = var.name }
  )
}

resource "aws_internet_gateway_attachment" "this" {
  count = var.create && var.attach_internet_gateway ? 1 : 0

  region = var.region

  vpc_id              = local.vpc_id
  internet_gateway_id = var.create_internet_gateway ? aws_internet_gateway.this[0].id : var.internet_gateway_id
}

resource "aws_egress_only_internet_gateway" "this" {
  count = var.create && var.create_egress_only_internet_gateway ? 1 : 0

  region = var.region

  vpc_id = local.vpc_id

  tags = merge(
    var.tags,
    { Name = var.name }
  )
}

################################################################################
# Customer Gateway(s)
################################################################################

resource "aws_customer_gateway" "this" {
  for_each = var.create && var.customer_gateways != null ? var.customer_gateways : {}

  region = var.region

  bgp_asn          = each.value.bgp_asn
  bgp_asn_extended = each.value.bgp_asn_extended
  certificate_arn  = each.value.certificate_arn
  device_name      = each.value.device_name
  ip_address       = each.value.ip_address
  type             = each.value.type

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}" },
  )
}

################################################################################
# VPN Gateway(s)
################################################################################

resource "aws_vpn_gateway" "this" {
  for_each = var.create && var.vpn_gateways != null ? var.vpn_gateways : {}

  region = var.region

  amazon_side_asn   = each.value.vpn_gateway_amazon_side_asn
  availability_zone = each.value.availability_zone
  vpc_id            = local.vpc_id

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}" },
  )
}

################################################################################
# Route53 Resolver
################################################################################

resource "aws_route53_resolver_dnssec_config" "this" {
  count = var.create && var.enable_dnssec_config ? 1 : 0

  region = var.region

  resource_id = aws_vpc.this[0].id
}

resource "aws_route53_resolver_query_log_config" "this" {
  count = var.create && var.enable_dns_query_logging && var.create_dns_query_log_config ? 1 : 0

  region = var.region

  destination_arn = var.dns_query_log_destination_arn
  name            = var.name

  tags = var.tags
}

resource "aws_route53_resolver_query_log_config_association" "this" {
  count = var.create && var.enable_dns_query_logging ? 1 : 0

  region = var.region

  resolver_query_log_config_id = var.create_dns_query_log_config ? aws_route53_resolver_query_log_config.this[0].id : var.dns_query_log_config_id
  resource_id                  = aws_vpc.this[0].id
}

################################################################################
# DNS Firewall Rule Group Association
################################################################################

resource "aws_route53_resolver_firewall_config" "this" {
  count = var.create && var.enable_dns_firewall ? 1 : 0

  region = var.region

  firewall_fail_open = var.dns_firewall_fail_open
  resource_id        = aws_vpc.this[0].id
}

resource "aws_route53_resolver_firewall_rule_group_association" "this" {
  for_each = var.create && var.enable_dns_firewall && var.dns_firewall_rule_group_associations != null ? var.dns_firewall_rule_group_associations : {}

  region = var.region

  firewall_rule_group_id = each.value.firewall_rule_group_id
  mutation_protection    = each.value.mutation_protection
  name                   = try(coalesce(each.value.name, "${var.name}-${each.key}"))
  priority               = each.value.priority
  vpc_id                 = aws_vpc.this[0].id

  tags = merge(
    var.tags,
    each.value.tags
  )
}

################################################################################
# Default Security Group for VPC created
################################################################################

resource "aws_default_security_group" "this" {
  count = var.create && var.manage_default_security_group ? 1 : 0

  region = var.region

  dynamic "egress" {
    for_each = var.default_security_group_egress_rules

    content {
      description      = egress.value.description
      from_port        = egress.value.from_port
      cidr_blocks      = egress.value.ipv4_cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
      prefix_list_ids  = egress.value.prefix_list_ids
      protocol         = egress.value.protocol
      security_groups  = egress.value.security_groups
      self             = egress.value.self
      to_port          = egress.value.to_port
    }
  }

  dynamic "ingress" {
    for_each = var.default_security_group_ingress_rules

    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      cidr_blocks      = ingress.value.ipv4_cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      prefix_list_ids  = ingress.value.prefix_list_ids
      protocol         = ingress.value.protocol
      security_groups  = ingress.value.security_groups
      self             = ingress.value.self
      to_port          = ingress.value.to_port
    }
  }

  vpc_id = local.vpc_id

  tags = merge(
    var.tags,
    { Name = "${var.name}-default" },
  )
}

################################################################################
# Default Network ACL for VPC created
################################################################################

resource "aws_default_network_acl" "this" {
  count = var.create && var.manage_default_network_acl ? 1 : 0

  region = var.region

  default_network_acl_id = aws_vpc.this[0].default_network_acl_id

  tags = merge(
    var.tags,
    { Name = "${var.name}-default" },
  )

  lifecycle {
    ignore_changes = [
      # Ignore subnets that are dynamically added/removed here
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl#managing-subnets-in-a-default-network-acl
      subnet_ids,
      # Ignore ingress/egress since those are controlled below
      ingress,
      egress,
    ]
  }
}

resource "aws_network_acl_rule" "default_ingress" {
  for_each = { for k, v in var.default_network_acl_ingress_rules : k => v if var.create && var.manage_default_network_acl }

  region = var.region

  egress          = false
  from_port       = each.value.from_port
  icmp_code       = each.value.icmp_code
  icmp_type       = each.value.icmp_type
  cidr_block      = each.value.ipv4_cidr_block
  ipv6_cidr_block = each.value.ipv6_cidr_block
  network_acl_id  = aws_default_network_acl.this[0].id
  protocol        = each.value.protocol
  rule_action     = each.value.rule_action
  rule_number     = each.key
  to_port         = try(coalesce(each.value.to_port, each.value.to_port), null)
}

resource "aws_network_acl_rule" "default_egress" {
  for_each = { for k, v in var.default_network_acl_egress_rules : k => v if var.create && var.manage_default_network_acl }

  region = var.region

  egress          = true
  from_port       = try(coalesce(each.value.from_port, each.value.to_port), null)
  icmp_code       = each.value.icmp_code
  icmp_type       = each.value.icmp_type
  cidr_block      = each.value.ipv4_cidr_block
  ipv6_cidr_block = each.value.ipv6_cidr_block
  network_acl_id  = aws_default_network_acl.this[0].id
  protocol        = each.value.protocol
  rule_action     = each.value.rule_action
  rule_number     = each.key
  to_port         = each.value.to_port
}

################################################################################
# Default Route Table for VPC created
################################################################################

resource "aws_default_route_table" "this" {
  count = var.create && var.manage_default_route_table ? 1 : 0

  region = var.region

  default_route_table_id = aws_vpc.this[0].default_route_table_id
  propagating_vgws       = var.default_route_table_propagating_vgws

  tags = merge(
    var.tags,
    { Name = "${var.name}-default" },
  )

  dynamic "timeouts" {
    for_each = var.default_route_table_timeouts != null ? [var.default_route_table_timeouts] : []

    content {
      create = each.value.create
      update = each.value.update
    }
  }

  lifecycle {
    ignore_changes = [
      # Ignore route since that is controlled below
      route,
    ]
  }
}

resource "aws_route" "default" {
  for_each = var.create && var.manage_default_route_table && var.default_route_table_routes != null ? var.default_route_table_routes : {}

  region = var.region

  route_table_id = aws_default_route_table.this[0].id

  destination_cidr_block      = each.value.destination_ipv4_cidr_block
  destination_ipv6_cidr_block = each.value.destination_ipv6_cidr_block
  destination_prefix_list_id  = each.value.destination_prefix_list_id

  # One of the following target arguments must be supplied:
  carrier_gateway_id        = each.value.carrier_gateway_id
  core_network_arn          = each.value.core_network_arn
  egress_only_gateway_id    = each.value.egress_only_gateway_id
  gateway_id                = each.value.gateway_id
  local_gateway_id          = each.value.local_gateway_id
  nat_gateway_id            = each.value.nat_gateway_id
  network_interface_id      = each.value.network_interface_id
  transit_gateway_id        = each.value.transit_gateway_id
  vpc_endpoint_id           = each.value.vpc_endpoint_id
  vpc_peering_connection_id = each.value.vpc_peering_connection_id

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}
