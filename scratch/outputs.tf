output "out" {
  description = "Tis a test (always has been)"
  # value       = element([for k, v in local.route_tables : lookup(v, "routes", {})], 0)
  value = local.inter
  # value       = element([for k, v in local.route_tables : zipmap(lookup(v, "subnet_keys", []), [for i in range(length(lookup(v, "subnet_keys", []))) : "${k}"])], 0)
}
