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

  ipv6_cidr_subnets = cidrsubnets(module.vpc.ipv6_cidr_block, 8, 8, 8, 8, 8, 8)
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

  # IPv6
  assign_generated_ipv6_cidr_block    = true
  create_egress_only_internet_gateway = true

  tags = local.tags
}

################################################################################
# Subnets
################################################################################

module "public_subnet" {
  source = "../../../modules/subnet"

  for_each = {
    "${local.region}a" = {
      ipv4_cidr_block = "10.0.101.0/24"
      ipv6_cidr_block = element(local.ipv6_cidr_subnets, 0)
    }
    "${local.region}b" = {
      ipv4_cidr_block = "10.0.102.0/24"
      ipv6_cidr_block = element(local.ipv6_cidr_subnets, 1)
    }
  }

  name   = "${local.name}-public-${each.key}"
  vpc_id = module.vpc.id

  availability_zone               = each.key
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true
  ipv4_cidr_block                 = each.value.ipv4_cidr_block
  ipv6_cidr_block                 = each.value.ipv6_cidr_block

  routes = {
    igw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = module.vpc.internet_gateway_id
    }
    igw_ipv6 = {
      destination_ipv6_cidr_block = "::/0"
      gateway_id                  = module.vpc.internet_gateway_id
    }
  }

  tags = local.tags
}

module "private_subnet" {
  source = "../../../modules/subnet"

  for_each = {
    "${local.region}a" = {
      ipv4_cidr_block = "10.0.1.0/24"
      ipv6_cidr_block = element(local.ipv6_cidr_subnets, 2)
    }
    "${local.region}b" = {
      ipv4_cidr_block = "10.0.2.0/24"
      ipv6_cidr_block = element(local.ipv6_cidr_subnets, 3)
    }
  }

  name   = "${local.name}-private-${each.key}"
  vpc_id = module.vpc.id

  availability_zone               = each.key
  assign_ipv6_address_on_creation = true
  ipv4_cidr_block                 = each.value.ipv4_cidr_block
  ipv6_cidr_block                 = each.value.ipv6_cidr_block

  routes = {
    eigw_ipv6 = {
      destination_ipv6_cidr_block = "::/0"
      egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
    }
  }

  tags = local.tags
}

module "database_subnet" {
  source = "../../../modules/subnet"

  for_each = {
    "${local.region}a" = {
      ipv4_cidr_block = "10.0.103.0/24"
      ipv6_cidr_block = element(local.ipv6_cidr_subnets, 4)
    }
    "${local.region}b" = {
      ipv4_cidr_block = "10.0.104.0/24"
      ipv6_cidr_block = element(local.ipv6_cidr_subnets, 5)
    }
  }

  name   = "${local.name}-database-${each.key}"
  vpc_id = module.vpc.id

  availability_zone               = each.key
  assign_ipv6_address_on_creation = true
  ipv4_cidr_block                 = each.value.ipv4_cidr_block
  ipv6_cidr_block                 = each.value.ipv6_cidr_block

  routes = {
    igw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = module.vpc.internet_gateway_id
    }
    eigw_ipv6 = {
      destination_ipv6_cidr_block = "::/0"
      egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
    }
  }

  tags = local.tags
}
