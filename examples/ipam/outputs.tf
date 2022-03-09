################################################################################
# IPAM
################################################################################

output "ipam_arn" {
  description = "Amazon Resource Name (ARN) of IPAM"
  value       = module.ipam.arn
}

output "ipam_id" {
  description = "The ID of the IPAM"
  value       = module.ipam.id
}

output "ipam_private_default_scope_id" {
  description = "The ID of the IPAM's private scope. A scope is a top-level container in IPAM. Each scope represents an IP-independent network. Scopes enable you to represent networks where you have overlapping IP space. The private scope is intended for private IP space"
  value       = module.ipam.private_default_scope_id
}

output "ipam_public_default_scope_id" {
  description = "The ID of the IPAM's private scope. A scope is a top-level container in IPAM. Each scope represents an IP-independent network. Scopes enable you to represent networks where you have overlapping IP space. The public scope is intended for all internet-routable IP space"
  value       = module.ipam.public_default_scope_id
}

output "ipam_scope_count" {
  description = "The number of scopes in the IPAM"
  value       = module.ipam.scope_count
}

################################################################################
# IPAM Scope
################################################################################

output "ipam_scopes" {
  description = "A map of the scopes created and their attributes"
  value       = module.ipam.scopes
}

################################################################################
# IPAM Pool Module - Regional
################################################################################

output "ipam_regional_pool" {
  description = "A map of the regional pools created and their attributes"
  value       = module.ipam_regional_pool
}

################################################################################
# IPAM Pool Module - Workload
################################################################################

output "ipam_pool_nonprod" {
  description = "A map of the 'nonproduction' pools created and their attributes"
  value       = module.ipam_regional_pool
}

output "ipam_pool_prod" {
  description = "A map of the 'production' pools created and their attributes"
  value       = module.ipam_regional_pool
}
