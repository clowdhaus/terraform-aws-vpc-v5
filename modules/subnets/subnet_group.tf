################################################################################
# DMS Replication Subnet Group
################################################################################

resource "aws_dms_replication_subnet_group" "this" {
  for_each = { for k, v in var.dms_replication_subnet_groups : k => v if var.create }

  replication_subnet_group_id          = each.value.replication_subnet_group_id
  replication_subnet_group_description = each.value.replication_subnet_group_description

  subnet_ids = [for subnet in [for key in try(each.value.associated_subnet_keys, []) : aws_subnet.this[key]] : subnet.id]

  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
}

################################################################################
# DocDB Subnet Group
################################################################################

resource "aws_docdb_subnet_group" "this" {
  for_each = { for k, v in var.docdb_subnet_groups : k => v if var.create }

  name        = try(each.value.use_name_prefix, false) ? null : try(each.value.name, each.key)
  name_prefix = try(each.value.use_name_prefix, false) ? "${try(each.value.name_prefix, each.key)}-" : null
  description = try(each.value.description, null)

  subnet_ids = [for subnet in [for key in try(each.value.associated_subnet_keys, []) : aws_subnet.this[key]] : subnet.id]

  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
}

################################################################################
# DAX Subnet Group
################################################################################

resource "aws_dax_subnet_group" "this" {
  for_each = { for k, v in var.dax_subnet_groups : k => v if var.create }

  name        = try(each.value.name, each.key)
  description = try(each.value.description, null)

  subnet_ids = [for subnet in [for key in try(each.value.associated_subnet_keys, []) : aws_subnet.this[key]] : subnet.id]
}

################################################################################
# Elasticache Subnet Group
################################################################################

resource "aws_elasticache_subnet_group" "this" {
  for_each = { for k, v in var.elasticache_subnet_groups : k => v if var.create }

  name        = try(each.value.name, each.key)
  description = try(each.value.description, null)

  subnet_ids = [for subnet in [for key in try(each.value.associated_subnet_keys, []) : aws_subnet.this[key]] : subnet.id]

  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
}

################################################################################
# MemoryDB Subnet Group
################################################################################

resource "aws_memorydb_subnet_group" "this" {
  for_each = { for k, v in var.memorydb_subnet_groups : k => v if var.create }

  name        = try(each.value.use_name_prefix, false) ? null : try(each.value.name, each.key)
  name_prefix = try(each.value.use_name_prefix, false) ? "${try(each.value.name_prefix, each.key)}-" : null
  description = try(each.value.description, null)

  subnet_ids = [for subnet in [for key in try(each.value.associated_subnet_keys, []) : aws_subnet.this[key]] : subnet.id]

  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
}

################################################################################
# Neptune Subnet Group
################################################################################

resource "aws_neptune_subnet_group" "this" {
  for_each = { for k, v in var.neptune_subnet_groups : k => v if var.create }

  name        = try(each.value.use_name_prefix, false) ? null : try(each.value.name, each.key)
  name_prefix = try(each.value.use_name_prefix, false) ? "${try(each.value.name_prefix, each.key)}-" : null
  description = try(each.value.description, null)

  subnet_ids = [for subnet in [for key in try(each.value.associated_subnet_keys, []) : aws_subnet.this[key]] : subnet.id]

  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
}

################################################################################
# DB Subnet Group
################################################################################

resource "aws_db_subnet_group" "this" {
  for_each = { for k, v in var.rds_subnet_groups : k => v if var.create }

  name        = try(each.value.use_name_prefix, false) ? null : try(each.value.name, each.key)
  name_prefix = try(each.value.use_name_prefix, false) ? "${try(each.value.name_prefix, each.key)}-" : null
  description = try(each.value.description, null)

  subnet_ids = [for subnet in [for key in try(each.value.associated_subnet_keys, []) : aws_subnet.this[key]] : subnet.id]

  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
}

################################################################################
# Redshift Subnet Group
################################################################################

resource "aws_redshift_subnet_group" "this" {
  for_each = { for k, v in var.redshift_subnet_groups : k => v if var.create }

  name        = try(each.value.name, each.key)
  description = try(each.value.description, null)

  subnet_ids = [for subnet in [for key in try(each.value.associated_subnet_keys, []) : aws_subnet.this[key]] : subnet.id]

  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
}
