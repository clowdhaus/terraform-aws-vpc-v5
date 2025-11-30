################################################################################
# VPC Endpoint(s)
################################################################################

data "aws_vpc_endpoint_service" "this" {
  for_each = { for k, v in var.vpc_endpoints : k => v if var.create }

  service      = try(each.value.service, each.key, null)
  service_name = try(each.value.service_name, null)
  # service_region = var.region # TODO - what is the correct way to set region for this data source?

  filter {
    name   = "service-type"
    values = [try(each.value.service_type, "Interface")]
  }
}

resource "aws_vpc_endpoint" "this" {
  for_each = { for k, v in var.vpc_endpoints : k => v if var.create }

  region = var.region

  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.this[each.key].service_name
  vpc_endpoint_type = try(each.value.service_type, "Interface")
  auto_accept       = try(each.value.auto_accept, null)

  security_group_ids  = try(each.value.service_type, "Interface") == "Interface" ? try(each.value.security_group_ids, var.vpc_endpoint_defaults.security_group_ids, []) : null
  subnet_ids          = try(each.value.service_type, "Interface") == "Interface" ? try(each.value.subnet_ids, var.vpc_endpoint_defaults.subnet_ids, []) : null
  route_table_ids     = try(each.value.service_type, "Interface") == "Gateway" ? try(each.value.route_table_ids, var.vpc_endpoint_defaults.route_table_ids, null) : null
  policy              = try(each.value.policy, var.vpc_endpoint_defaults.policy, null)
  private_dns_enabled = try(each.value.service_type, "Interface") == "Interface" ? try(each.value.private_dns_enabled, var.vpc_endpoint_defaults.private_dns_enabled, null) : null

  tags = merge(
    var.tags,
    { Name = data.aws_vpc_endpoint_service.this[each.key].service },
    try(each.value.tags, {})
  )

  timeouts {
    create = try(var.vpc_endpoint_timeouts.create, null)
    update = try(var.vpc_endpoint_timeouts.update, null)
    delete = try(var.vpc_endpoint_timeouts.delete, null)
  }
}
