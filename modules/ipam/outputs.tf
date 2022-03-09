################################################################################
# IPAM
################################################################################

output "arn" {
  description = "Amazon Resource Name (ARN) of IPAM"
  value       = try(aws_vpc_ipam.this[0].arn, null)
}

output "id" {
  description = "The ID of the IPAM"
  value       = try(aws_vpc_ipam.this[0].id, null)
}

output "private_default_scope_id" {
  description = "The ID of the IPAM's private scope. A scope is a top-level container in IPAM. Each scope represents an IP-independent network. Scopes enable you to represent networks where you have overlapping IP space. The private scope is intended for private IP space"
  value       = try(aws_vpc_ipam.this[0].private_default_scope_id, null)
}

output "public_default_scope_id" {
  description = "The ID of the IPAM's private scope. A scope is a top-level container in IPAM. Each scope represents an IP-independent network. Scopes enable you to represent networks where you have overlapping IP space. The public scope is intended for all internet-routable IP space"
  value       = try(aws_vpc_ipam.this[0].public_default_scope_id, null)
}

output "scope_count" {
  description = "The number of scopes in the IPAM"
  value       = try(aws_vpc_ipam.this[0].scope_count, null)
}

################################################################################
# IPAM Scope
################################################################################

output "scopes" {
  description = "A map of the scopes created and their attributes"
  value       = aws_vpc_ipam_scope.this
}

################################################################################
# IPAM Pool
################################################################################

output "pool_arn" {
  description = "ARN of the IPAM Pool"
  value       = module.vpc_ipam_pool.arn
}

output "pool_id" {
  description = "ID of the IPAM Pool"
  value       = module.vpc_ipam_pool.id
}

output "pool_state" {
  description = "State of the IPAM Pool"
  value       = module.vpc_ipam_pool.state
}

################################################################################
# IPAM Pool CIDR
################################################################################

output "pool_cidr_id" {
  description = "The ID of the IPAM Pool Cidr concatenated with the IPAM Pool ID"
  value       = module.vpc_ipam_pool.cidr_id
}

################################################################################
# IPAM Pool Allocation
################################################################################

output "pool_cidr_allocations" {
  description = "A map of the CIDR allocations provisioned and their attributes"
  value       = module.vpc_ipam_pool.cidr_allocations
}

################################################################################
# IPAM Preview Next CIDR
################################################################################

output "pool_preview_next_cidr" {
  description = "The previewed CIDR from the pool"
  value       = module.vpc_ipam_pool.preview_next_cidr
}

output "pool_preview_next_cidr_id" {
  description = "The ID of the preview"
  value       = module.vpc_ipam_pool.preview_next_cidr_id
}
