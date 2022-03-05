################################################################################
# Default Security Group for VPC created
################################################################################

resource "aws_default_security_group" "this" {
  count = var.create && var.manage_default_security_group ? 1 : 0

  vpc_id = local.vpc_id

  dynamic "ingress" {
    for_each = var.default_security_group_ingress
    content {
      self             = try(ingress.value.self, null)
      cidr_blocks      = try(ingress.value.cidr_blocks, null)
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
    for_each = var.default_security_group_egress
    content {
      self             = try(egress.value.self, null)
      cidr_blocks      = try(egress.value.cidr_blocks, null)
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

  # # The value of subnet_ids should be any subnet IDs that are not set as subnet_ids
  # #   for any of the non-default network ACLs
  # # !!! TODO - this will need to be updated
  # subnet_ids = setsubtract(
  #   aws_subnet.this.*.id,
  #   aws_network_acl.this.*.subnet_ids,
  # )

  dynamic "ingress" {
    for_each = var.default_network_acl_ingress
    content {
      action          = ingress.value.action
      from_port       = ingress.value.from_port
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      to_port         = ingress.value.to_port
      cidr_block      = try(ingress.value.cidr_block, null)
      icmp_code       = try(ingress.value.icmp_code, null)
      icmp_type       = try(ingress.value.icmp_type, null)
      ipv6_cidr_block = try(ingress.value.ipv6_cidr_block, null)
    }
  }
  dynamic "egress" {
    for_each = var.default_network_acl_egress
    content {
      action          = egress.value.action
      from_port       = egress.value.from_port
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_no
      to_port         = egress.value.to_port
      cidr_block      = try(egress.value.cidr_block, null)
      icmp_code       = try(egress.value.icmp_code, null)
      icmp_type       = try(egress.value.icmp_type, null)
      ipv6_cidr_block = try(egress.value.ipv6_cidr_block, null)
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
      cidr_block                 = route.value.cidr_block
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
# Default DHCP Options
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
