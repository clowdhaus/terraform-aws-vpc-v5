################################################################################
# IPAM Organization Admin Account
################################################################################

resource "aws_vpc_ipam_organization_admin_account" "this" {
  count = var.create && var.delegate_admin_account ? 1 : 0

  delegated_admin_account_id = var.delegated_admin_account_id
}

################################################################################
# IPAM
################################################################################

resource "aws_vpc_ipam" "this" {
  count = var.create ? 1 : 0

  description = var.description

  dynamic "operating_regions" {
    for_each = var.operating_regions
    content {
      region_name = operating_regions.value
    }
  }

  tags = var.tags
}

################################################################################
# IPAM Scope
################################################################################

resource "aws_vpc_ipam_scope" "this" {
  for_each = { for k, v in var.scopes : k => v if var.create }

  ipam_id     = aws_vpc_ipam.this[0].id
  description = try(each.value.description, null)
}

################################################################################
# IPAM Pool
################################################################################

resource "aws_vpc_ipam_pool" "this" {
  for_each = { for k, v in var.pools : k => v if var.create }

  description = try(each.value.description, null)

  address_family                    = try(each.value.address_family, null)
  publicly_advertisable             = try(each.value.publicly_advertisable, null)
  allocation_default_netmask_length = try(each.value.allocation_default_netmask_length, null)
  allocation_max_netmask_length     = try(each.value.allocation_max_netmask_length, null)
  allocation_min_netmask_length     = try(each.value.allocation_min_netmask_length, null)
  allocation_resource_tags          = try(each.value.allocation_resource_tags, null)
  auto_import                       = try(each.value.auto_import, null)
  aws_service                       = try(each.value.aws_service, null)
  ipam_scope_id                     = try(each.value.use_private_scope, true) ? try(aws_vpc_ipam.this[each.value.scope_key].private_default_scope_id, each.value.ipam_scope_id, null) : try(aws_vpc_ipam.this[each.value.scope_key].public_default_scope_id, each.value.ipam_scope_id, null)
  locale                            = try(each.value.locale, null)
  source_ipam_pool_id               = try(each.value.source_ipam_pool_id, null)

  tags = merge(var.tags, try(each.value.tags, {}))
}
