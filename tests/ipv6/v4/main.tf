provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
  name   = "ipv6"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  availability_zones = ["${local.region}a", "${local.region}b"]

  ipv4_cidr_groups = chunklist(cidrsubnets(module.vpc.ipv4_cidr_block, 8, 8, 8, 8, 8, 8), 2)
  ipv4_subnet_maps = [for cidrs in local.ipv4_cidr_groups : zipmap(local.availability_zones, cidrs)]

  ipv6_cidr_groups = chunklist(cidrsubnets(module.vpc.ipv6_cidr_block, 8, 8, 8, 8, 8, 8), 2)
  ipv6_subnet_maps = [for cidrs in local.ipv6_cidr_groups : zipmap(local.availability_zones, cidrs)]
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../../"

  name            = local.name
  ipv4_cidr_block = "10.0.0.0/16"

  # Not in v3.x
  enable_dnssec_config          = false
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false

  assign_generated_ipv6_cidr_block = true

  tags = local.tags
}

module "public_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

  subnets_default = {
    assign_ipv6_address_on_creation = true
    map_public_ip_on_launch         = true
  }

  subnets = merge(
    { for k, v in element(local.ipv4_subnet_maps, 0) : "${k}-ipv4" => {
      ipv4_cidr_block   = v
      availability_zone = k
    } },
    { for k, v in element(local.ipv6_subnet_maps, 0) : "${k}-ipv6" => {
      ipv6_cidr_block   = v
      availability_zone = k
    } }
  )

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b"]
      routes = {
        igw_ipv4 = {
          destination_cidr_block = "0.0.0.0/0"
          gateway_id             = module.vpc.internet_gateway_id
        }
      }
    }
  }

  tags = local.tags
}

module "private_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

  subnets_default = {
    assign_ipv6_address_on_creation = true
  }

  subnets = merge(
    { for k, v in element(local.ipv4_subnet_maps, 1) : "${k}-ipv4" => {
      ipv4_cidr_block   = v
      availability_zone = k
    } },
    { for k, v in element(local.ipv6_subnet_maps, 1) : "${k}-ipv6" => {
      ipv6_cidr_block   = v
      availability_zone = k
    } }
  )

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b"]
      routes                 = {}
    }
  }

  tags = local.tags
}

module "database_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-database"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

  subnets_default = {
    assign_ipv6_address_on_creation = true
  }

  subnets = merge(
    { for k, v in element(local.ipv4_subnet_maps, 2) : "${k}-ipv4" => {
      ipv4_cidr_block   = v
      availability_zone = k
    } },
    { for k, v in element(local.ipv6_subnet_maps, 2) : "${k}-ipv6" => {
      ipv6_cidr_block   = v
      availability_zone = k
    } }
  )

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b"]
      routes                 = {}
    }
  }

  # rds_subnet_groups = {
  #   database = {
  #     name                   = local.name
  #     description            = "Database subnet group for ${local.name}"
  #     associated_subnet_keys = ["${local.region}a", "${local.region}b"]

  #     tags = {
  #       Name = local.name
  #     }
  #   }
  # }

  tags = local.tags
}
