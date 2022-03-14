locals {
  region = "us-east-1"

  route_tables = {
    "${local.region}a" = {
      associated_subnet_keys = ["${local.region}a"]
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
    "${local.region}b" = {
      associated_subnet_keys = ["${local.region}b"]
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

  subnet_route_table_associations = [for k, v in local.route_tables : zipmap(lookup(v, "associated_subnet_keys", []), [for i in range(length(lookup(v, "associated_subnet_keys", []))) : k])]


  inter = { for k, v in local.subnet_route_table_associations : k => { gateway_key = element(keys(v), 0), subnet_key = element(values(v), 0) } }

  # element(values({
  #   for k, v in local.route_tables : k => {
  #     for k2, v2 in try(v.routes, {}) : k2 => merge({ route_table_key = k }, v2)
  #   }
  # }), 0)

  # buckets       = ["blue", "green", "red"]
  # bucket_filter = ["blue", "green"]

  availability_zones = ["${local.region}a", "${local.region}b"]
  cidr_chunks        = chunklist(cidrsubnets("fd00:fd12:3456:7890::/56", 8, 8, 8, 8, 8, 8), 2)
  subnet_maps        = [for cidrs in local.cidr_chunks : zipmap(local.availability_zones, cidrs)]

  # subnets = { for k, v in element(local.subnet_maps, 0) : k => {
  #   ipv6_cidr_block   = v
  #   availability_zone = k
  # } }

  subnets_in = {
    "${local.region}a" = {
      ipv4_cidr_block    = "10.98.1.0/24"
      availability_zone  = "${local.region}a"
      create_nat_gateway = true
      # ec2_subnet_cidr_reservations = {
      #   one = {
      #     description      = "Example EC2 subnet CIDR reservation"
      #     cidr_block       = "10.98.1.0/28"
      #     reservation_type = "prefix"
      #   }
      #   two = {
      #     description      = "Example EC2 subnet CIDR reservation"
      #     cidr_block       = "10.98.1.16/28"
      #     reservation_type = "prefix"
      #   }
      # }
      ec2_subnet_cidr_reservations = [{
        description      = "Example EC2 subnet CIDR reservation"
        cidr_block       = "10.98.1.0/28"
        reservation_type = "prefix"
        }, {
        description      = "Example EC2 subnet CIDR reservation"
        cidr_block       = "10.98.1.16/28"
        reservation_type = "prefix"
      }]
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.98.2.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.98.3.0/24"
      availability_zone = "${local.region}c"
    }
  }

  # subnets = [for k, v in local.subnets_in : zipmap(
  #   [for i in range(length(keys(v.ec2_subnet_cidr_reservations))) : k],
  # v.ec2_subnet_cidr_reservations[*].cidr_block) if can(v.ec2_subnet_cidr_reservations)]

  subnets = { for k, v in local.subnets_in :
    k => v.ec2_subnet_cidr_reservations if can(v.ec2_subnet_cidr_reservations)
  }
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
