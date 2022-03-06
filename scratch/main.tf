locals {
  region = "us-east-1"

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b"]
      routes = {
        igw = {
          destination_cidr_block = "0.0.0.0/0"
          gateway_id             = "igw-xxxxxx"
        }
        nat = {
          destination_cidr_block = "0.0.0.0/0"
          gateway_id             = "nat-xxxxxx"
        }
      }
    }
  }

  inter = element(values({
    for k, v in local.route_tables : k => {
      for k2, v2 in try(v.routes, {}) : k2 => merge({ route_table_key = k }, v2)
    }
  }), 0)
}

output "out" {
  description = "Tis a test (always has been)"
  # value       = element([for k, v in local.route_tables : lookup(v, "routes", {})], 0)
  value = local.inter
  # value       = element([for k, v in local.route_tables : zipmap(lookup(v, "subnet_keys", []), [for i in range(length(lookup(v, "subnet_keys", []))) : "${k}"])], 0)
}
