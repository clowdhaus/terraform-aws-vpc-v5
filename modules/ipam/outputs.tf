################################################################################
# IPAM Organization Admin Account
################################################################################

output "organization_admin_account_arn" {
  description = "The Organizations ARN for the delegate account"
  value       = try(aws_vpc_ipam_organization_admin_account.this[0].arn, null)
}

output "organization_admin_account_id" {
  description = "The Organizations member account ID that you want to enable as the IPAM account"
  value       = try(aws_vpc_ipam_organization_admin_account.this[0].id, null)
}

output "organization_admin_account_email" {
  description = "The Organizations email for the delegate account"
  value       = try(aws_vpc_ipam_organization_admin_account.this[0].email, null)
}

output "organization_admin_account_name" {
  description = "The Organizations name for the delegate account"
  value       = try(aws_vpc_ipam_organization_admin_account.this[0].name, null)
}

output "organization_admin_account_service_principal" {
  description = "The AWS service principal"
  value       = try(aws_vpc_ipam_organization_admin_account.this[0].service_principal, null)
}

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
