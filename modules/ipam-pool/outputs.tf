################################################################################
# IPAM Pool
################################################################################

output "arn" {
  description = "ARN of the IPAM Pool"
  value       = try(aws_vpc_ipam_pool.this[0].arn, null)
}

output "id" {
  description = "ID of the IPAM Pool"
  value       = try(aws_vpc_ipam_pool.this[0].id, null)
}

output "state" {
  description = "State of the IPAM Pool"
  value       = try(aws_vpc_ipam_pool.this[0].state, null)
}

output "locale" {
  description = "Locale of the IPAM Pool"
  value       = try(aws_vpc_ipam_pool.this[0].locale, null)
}

################################################################################
# IPAM Pool CIDR
################################################################################

output "cidr_id" {
  description = "The ID of the IPAM Pool Cidr concatenated with the IPAM Pool ID"
  value       = try(aws_vpc_ipam_pool_cidr.this[0].id, null)
}

################################################################################
# IPAM Pool Allocation
################################################################################

output "cidr_allocations" {
  description = "A map of the CIDR allocations provisioned and their attributes"
  value       = aws_vpc_ipam_pool_cidr_allocation.this
}

################################################################################
# IPAM Preview Next CIDR
################################################################################

output "preview_next_cidr" {
  description = "The previewed CIDR from the pool"
  value       = try(aws_vpc_ipam_preview_next_cidr.this[0].cidr, null)
}

output "preview_next_cidr_id" {
  description = "The ID of the preview"
  value       = try(aws_vpc_ipam_preview_next_cidr.this[0].id, null)
}
