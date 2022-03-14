locals {
  region = "us-east-1"

  # route_tables = {
  #   "${local.region}a" = {
  #     associated_subnet_keys = ["${local.region}a"]
  #     routes = {
  #       igw = {
  #         destination_cidr_block = "0.0.0.0/0"
  #         gateway_id             = "igw-xxxxxx"
  #       }
  #       nat = {
  #         destination_cidr_block = "0.0.0.0/0"
  #         gateway_id             = "nat-xxxxxx"
  #       }
  #     }
  #   }
  #   "${local.region}b" = {
  #     associated_subnet_keys = ["${local.region}b"]
  #     routes = {
  #       igw = {
  #         destination_cidr_block = "0.0.0.0/0"
  #         gateway_id             = "igw-xxxxxx"
  #       }
  #       nat = {
  #         destination_cidr_block = "0.0.0.0/0"
  #         gateway_id             = "nat-xxxxxx"
  #       }
  #     }
  #   }
  # }

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


  subnets = { for k, v in local.subnets_in :
    k => v.ec2_subnet_cidr_reservations if can(v.ec2_subnet_cidr_reservations)
  }
}
