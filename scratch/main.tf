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

  # buckets       = ["blue", "green", "red"]
  # bucket_filter = ["blue", "green"]

  availability_zones = ["${local.region}a", "${local.region}b"]
  cidr_chunks      = chunklist(cidrsubnets("fd00:fd12:3456:7890::/56", 8, 8, 8, 8, 8, 8), 2)
  subnet_maps = [for cidrs in local.cidr_chunks : zipmap(local.availability_zones, cidrs)]

  subnets = { for k, v in element(local.subnet_maps, 0) : k => {
    ipv6_cidr_block   = v
    availability_zone = k
  } }
}

output "subnet_maps" {
  value = local.subnet_maps
}

output "subnets" {
  value = local.subnets
}

# resource "aws_s3_bucket" "this" {
#   for_each = toset(local.buckets)
#   bucket   = "my-temp-bux-${each.value}"

#   force_destroy = true
# }

# output "buckets" {
#   value = [for bucket in [for filt in local.bucket_filter : aws_s3_bucket.this[filt]] : bucket.id]
#   # value = aws_s3_bucket.this
# }
