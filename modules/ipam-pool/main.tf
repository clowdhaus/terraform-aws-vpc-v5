################################################################################
# IPAM Pool
################################################################################

resource "aws_vpc_ipam_pool" "this" {
  count = var.create ? 1 : 0

  region = var.region

  description = var.description

  address_family                    = var.address_family
  publicly_advertisable             = lower(var.address_family) == "ipv4" ? null : var.publicly_advertisable
  allocation_default_netmask_length = var.allocation_default_netmask_length
  allocation_max_netmask_length     = var.allocation_max_netmask_length
  allocation_min_netmask_length     = var.allocation_min_netmask_length
  allocation_resource_tags          = var.allocation_resource_tags
  auto_import                       = var.auto_import
  aws_service                       = var.aws_service
  ipam_scope_id                     = var.ipam_scope_id
  locale                            = var.locale
  source_ipam_pool_id               = var.source_ipam_pool_id

  tags = var.tags
}

################################################################################
# IPAM Pool CIDR
################################################################################

resource "aws_vpc_ipam_pool_cidr" "this" {
  count = var.create ? 1 : 0

  region = var.region

  cidr         = var.cidr
  ipam_pool_id = aws_vpc_ipam_pool.this[0].id

  dynamic "cidr_authorization_context" {
    for_each = [var.cidr_authorization_context]
    content {
      message   = try(cidr_authorization_context.value.message, null)
      signature = try(cidr_authorization_context.value.signature, null)
    }
  }
}

################################################################################
# IPAM Pool Allocation
################################################################################

resource "aws_vpc_ipam_pool_cidr_allocation" "this" {
  for_each = { for k, v in var.cidr_allocations : k => v if var.create }

  region = var.region

  cidr             = try(each.value.cidr, null)
  description      = try(each.value.description, null)
  disallowed_cidrs = try(each.value.disallowed_cidrs, var.disallowed_cidrs)
  ipam_pool_id     = aws_vpc_ipam_pool.this[0].id
  netmask_length   = try(each.value.netmask_length, null)

  depends_on = [
    aws_vpc_ipam_pool_cidr.this
  ]
}

################################################################################
# IPAM Preview Next CIDR
################################################################################

resource "aws_vpc_ipam_preview_next_cidr" "this" {
  count = var.create && var.preview_next_cidr ? 1 : 0

  region = var.region

  disallowed_cidrs = var.disallowed_cidrs
  ipam_pool_id     = aws_vpc_ipam_pool.this[0].id
  netmask_length   = var.preview_netmask_length

  depends_on = [
    aws_vpc_ipam_pool_cidr.this
  ]
}

################################################################################
# RAM Resource Association
################################################################################

resource "aws_ram_resource_association" "this" {
  for_each = { for k, v in var.ram_resource_associations : k => v if var.create }

  region = var.region

  resource_arn       = aws_vpc_ipam_pool.this[0].arn
  resource_share_arn = each.value.resource_share_arn
}
