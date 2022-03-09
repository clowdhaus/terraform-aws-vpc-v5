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

locals {
  # We can create more private scopes, but cannot create more public scopes
  private_scope_id = var.create ? try(aws_vpc_ipam_scope.this[var.pool_scope_key].id, aws_vpc_ipam.this[0].private_default_scope_id, null) : null
  public_scope_id  = var.create ? try(aws_vpc_ipam.this[0].public_default_scope_id, null) : null
}

module "vpc_ipam_pool" {
  source = "../ipam-pool"

  create = var.create && var.create_ipam_pool

  description                       = var.pool_description
  address_family                    = var.pool_address_family
  publicly_advertisable             = var.pool_publicly_advertisable
  allocation_default_netmask_length = var.pool_allocation_default_netmask_length
  allocation_max_netmask_length     = var.pool_allocation_max_netmask_length
  allocation_min_netmask_length     = var.pool_allocation_min_netmask_length
  allocation_resource_tags          = var.pool_allocation_resource_tags
  auto_import                       = var.pool_auto_import
  aws_service                       = var.pool_aws_service
  ipam_scope_id                     = var.pool_use_private_scope ? local.private_scope_id : local.public_scope_id
  locale                            = var.pool_locale

  # This is the top-most pool
  # source_ipam_pool_id = var.pool_source_ipam_pool_id

  cidr                       = var.pool_cidr
  cidr_authorization_context = var.pool_cidr_authorization_context
  cidr_allocations           = var.pool_cidr_allocations

  preview_next_cidr      = var.pool_preview_next_cidr
  disallowed_cidrs       = var.pool_disallowed_cidrs
  preview_netmask_length = var.pool_preview_netmask_length

  tags = merge(var.tags, var.pool_tags)
}
