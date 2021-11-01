################################################################################
# Default Security Group for VPC created
################################################################################

resource "aws_default_security_group" "this" {
  count = var.create && var.manage_default_security_group ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  dynamic "ingress" {
    for_each = var.default_security_group_ingress
    content {
      self             = lookup(ingress.value, "self", null)
      cidr_blocks      = compact(split(",", lookup(ingress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(ingress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(ingress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(ingress.value, "security_groups", "")))
      description      = lookup(ingress.value, "description", null)
      from_port        = lookup(ingress.value, "from_port", 0)
      to_port          = lookup(ingress.value, "to_port", 0)
      protocol         = lookup(ingress.value, "protocol", "-1")
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress
    content {
      self             = lookup(egress.value, "self", null)
      cidr_blocks      = compact(split(",", lookup(egress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(egress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(egress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(egress.value, "security_groups", "")))
      description      = lookup(egress.value, "description", null)
      from_port        = lookup(egress.value, "from_port", 0)
      to_port          = lookup(egress.value, "to_port", 0)
      protocol         = lookup(egress.value, "protocol", "-1")
    }
  }

  tags = merge(
    { "Name" = coalesce(var.default_security_group_name, "${var.name}-default") },
    var.tags,
    var.default_security_group_tags,
  )
}

################################################################################
# Default Network ACL for VPC created
################################################################################

resource "aws_default_network_acl" "this" {
  count = var.create && var.manage_default_network_acl ? 1 : 0

  default_network_acl_id = try(aws_vpc.this[0].default_network_acl_id, null)

  # The value of subnet_ids should be any subnet IDs that are not set as subnet_ids
  #   for any of the non-default network ACLs
  # !!! TODO - this will need to be updated
  # subnet_ids = setsubtract(
  #   compact(flatten([
  #     aws_subnet.public.*.id,
  #     aws_subnet.private.*.id,
  #     aws_subnet.intra.*.id,
  #     aws_subnet.database.*.id,
  #     aws_subnet.redshift.*.id,
  #     aws_subnet.elasticache.*.id,
  #     aws_subnet.outpost.*.id,
  #   ])),
  #   compact(flatten([
  #     aws_network_acl.public.*.subnet_ids,
  #     aws_network_acl.private.*.subnet_ids,
  #     aws_network_acl.intra.*.subnet_ids,
  #     aws_network_acl.database.*.subnet_ids,
  #     aws_network_acl.redshift.*.subnet_ids,
  #     aws_network_acl.elasticache.*.subnet_ids,
  #     aws_network_acl.outpost.*.subnet_ids,
  #   ]))
  # )

  dynamic "ingress" {
    for_each = var.default_network_acl_ingress
    content {
      action          = ingress.value.action
      from_port       = ingress.value.from_port
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      to_port         = ingress.value.to_port
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
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
      cidr_block      = lookup(egress.value, "cidr_block", null)
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
    }
  }

  tags = merge(
    { "Name" = coalesce(var.default_network_acl_name, "${var.name}-default") },
    var.tags,
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
      ipv6_cidr_block            = lookup(route.value, "ipv6_cidr_block", null)
      destination_prefix_list_id = lookup(route.value, "destination_prefix_list_id", null)

      # One of the following targets must be provided
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  dynamic "timeouts" {
    for_each = var.default_route_table_timeouts
    content {
      create = lookup(each.value, "create", null)
      update = lookup(each.value, "update", null)
    }
  }

  tags = merge(
    { "Name" = coalesce(var.default_route_table_name, "${var.name}-default") },
    var.tags,
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
    { "Name" = coalesce(var.default_dhcp_options_name, "${var.name}-default") },
    var.tags,
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
    { "Name" = coalesce(var.default_vpc_name, "default") },
    var.tags,
    var.default_vpc_tags,
  )
}
