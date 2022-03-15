locals {
  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = try(aws_vpc_ipv4_cidr_block_association.this[0].vpc_id, aws_vpc.this[0].id, null)
}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  count = var.create ? 1 : 0

  cidr_block          = var.ipv4_cidr_block
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
  cidr_block          = try(each.value.ipv4_cidr_block, null)
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
# Route53 Resolver
################################################################################

resource "aws_route53_resolver_dnssec_config" "this" {
  count = var.create && var.enable_dnssec_config ? 1 : 0

  resource_id = aws_vpc.this[0].id
}

resource "aws_route53_resolver_query_log_config" "this" {
  count = var.create && var.enable_dns_query_logging ? 1 : 0

  name            = var.name
  destination_arn = var.dns_query_log_destintion_arn

  tags = var.tags
}

resource "aws_route53_resolver_query_log_config_association" "this" {
  count = var.create && var.enable_dns_query_logging ? 1 : 0

  resolver_query_log_config_id = aws_route53_resolver_query_log_config.this[0].id
  resource_id                  = aws_vpc.this[0].id
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

  tags = merge(
    var.tags,
    { Name = var.name },
    var.internet_gateway_tags,
  )
}

resource "aws_internet_gateway_attachment" "this" {
  count = var.create && var.attach_internet_gateway ? 1 : 0

  vpc_id              = local.vpc_id
  internet_gateway_id = var.create_internet_gateway ? aws_internet_gateway.this[0].id : var.internet_gateway_id
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
  type       = try(each.value.type, "ipsec.1") # required but only one value accepted currently

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

################################################################################
# Default Security Group for VPC created
################################################################################

resource "aws_default_security_group" "this" {
  count = var.create && var.manage_default_security_group ? 1 : 0

  vpc_id = local.vpc_id

  dynamic "ingress" {
    for_each = var.default_security_group_ingress_rules
    content {
      self             = try(ingress.value.self, null)
      cidr_blocks      = try(ingress.value.ipv4_cidr_blocks, null)
      ipv6_cidr_blocks = try(ingress.value.ipv6_cidr_blocks, null)
      prefix_list_ids  = try(ingress.value.prefix_list_ids, null)
      security_groups  = try(ingress.value.security_groups, null)
      description      = try(ingress.value.description, null)
      from_port        = try(ingress.value.from_port, null)
      to_port          = try(ingress.value.to_port, null)
      protocol         = try(ingress.value.protocol, null)
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress_rules
    content {
      self             = try(egress.value.self, null)
      cidr_blocks      = try(egress.value.ipv4_cidr_blocks, null)
      ipv6_cidr_blocks = try(egress.value.ipv6_cidr_blocks, null)
      prefix_list_ids  = try(egress.value.prefix_list_ids, null)
      security_groups  = try(egress.value.security_groups, null)
      description      = try(egress.value.description, null)
      from_port        = try(egress.value.from_port, null)
      to_port          = try(egress.value.to_port, null)
      protocol         = try(egress.value.protocol, null)
    }
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-default" },
    var.default_security_group_tags,
  )
}

################################################################################
# Default Network ACL for VPC created
################################################################################

resource "aws_default_network_acl" "this" {
  count = var.create && var.manage_default_network_acl ? 1 : 0

  default_network_acl_id = try(aws_vpc.this[0].default_network_acl_id, null)

  dynamic "ingress" {
    for_each = var.default_network_acl_ingress_rules
    content {
      action          = ingress.value.rule_action # to match regular ACL rule
      from_port       = ingress.value.from_port
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_number # to match regular ACL rule
      to_port         = ingress.value.to_port
      cidr_block      = try(ingress.value.ipv4_cidr_block, null)
      ipv6_cidr_block = try(ingress.value.ipv6_cidr_block, null)
      icmp_code       = try(ingress.value.icmp_code, null)
      icmp_type       = try(ingress.value.icmp_type, null)
    }
  }
  dynamic "egress" {
    for_each = var.default_network_acl_egress_rules
    content {
      action          = egress.value.rule_action # to match regular ACL rule
      from_port       = egress.value.from_port
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_number # to match regular ACL rule
      to_port         = egress.value.to_port
      cidr_block      = try(egress.value.ipv4_cidr_block, null)
      ipv6_cidr_block = try(egress.value.ipv6_cidr_block, null)
      icmp_code       = try(egress.value.icmp_code, null)
      icmp_type       = try(egress.value.icmp_type, null)
    }
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-default" },
    var.default_network_acl_tags,
  )
}

################################################################################
# Default Route Table for VPC created
################################################################################

resource "aws_default_route_table" "this" {
  count = var.create && var.manage_default_route_table ? 1 : 0

  default_route_table_id = aws_vpc.this[0].default_route_table_id
  propagating_vgws       = var.default_route_table_propagating_vgws

  dynamic "route" {
    for_each = var.default_route_table_routes
    content {
      # One of the following destinations must be provided
      cidr_block                 = route.value.ipv4_cidr_block
      ipv6_cidr_block            = try(route.value.ipv6_cidr_block, null)
      destination_prefix_list_id = try(route.value.destination_prefix_list_id, null)

      # One of the following targets must be provided
      egress_only_gateway_id    = try(route.value.egress_only_gateway_id, null)
      gateway_id                = try(route.value.gateway_id, null)
      instance_id               = try(route.value.instance_id, null)
      nat_gateway_id            = try(route.value.nat_gateway_id, null)
      network_interface_id      = try(route.value.network_interface_id, null)
      transit_gateway_id        = try(route.value.transit_gateway_id, null)
      vpc_endpoint_id           = try(route.value.vpc_endpoint_id, null)
      vpc_peering_connection_id = try(route.value.vpc_peering_connection_id, null)
    }
  }

  dynamic "timeouts" {
    for_each = var.default_route_table_timeouts
    content {
      create = try(each.value.create, null)
      update = try(each.value.update, null)
    }
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-default" },
    var.default_route_table_tags,
  )
}

################################################################################
# Account Default VPC
################################################################################

resource "aws_default_vpc" "this" {
  count = var.create && var.manage_default_vpc ? 1 : 0

  enable_dns_support   = var.default_vpc_enable_dns_support
  enable_dns_hostnames = var.default_vpc_enable_dns_hostnames
  enable_classiclink   = var.default_vpc_enable_classiclink

  tags = merge(
    var.tags,
    { Name = "default" },
    var.default_vpc_tags,
  )
}

################################################################################
# Account Default DHCP Options
################################################################################

resource "aws_default_vpc_dhcp_options" "this" {
  count = var.create && var.manage_default_dhcp_options ? 1 : 0

  netbios_name_servers = var.default_dhcp_options_netbios_name_servers
  netbios_node_type    = var.default_dhcp_options_netbios_node_type
  owner_id             = var.default_dhcp_options_owner_id

  tags = merge(
    var.tags,
    { Name = "${var.name}-default" },
    var.default_dhcp_options_tags,
  )
}
