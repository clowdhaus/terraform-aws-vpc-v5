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
