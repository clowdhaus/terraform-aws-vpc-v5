provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
  name   = "vpc-ex-simple"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source = "../../../"

  name            = local.name
  ipv4_cidr_block = "10.0.0.0/16"

  assign_generated_ipv6_cidr_block    = true
  create_egress_only_internet_gateway = true

  # Not in v3.x
  enable_dnssec_config          = false
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false

  vpc_tags = {
    Name = "vpc-name"
  }

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
    }
    "${local.region}b" = {
      ipv4_cidr_block = "10.0.102.0/24"
    }
    "${local.region}c" = {
      ipv4_cidr_block = "10.0.103.0/24"
    }
  }

  name   = "${local.name}-public-${each.key}"
  vpc_id = module.vpc.id

  availability_zone       = each.key
  map_public_ip_on_launch = true
  ipv4_cidr_block         = each.value.ipv4_cidr_block

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

  tags = merge(local.tags, {
    Name = "overridden-name-public"
  })
}

module "private_subnet" {
  source = "../../../modules/subnet"

  for_each = {
    "${local.region}a" = {
      ipv4_cidr_block = "10.0.1.0/24"
    }
    "${local.region}b" = {
      ipv4_cidr_block = "10.0.2.0/24"
    }
    "${local.region}c" = {
      ipv4_cidr_block = "10.0.3.0/24"
    }
  }

  name   = "${local.name}-private-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.ipv4_cidr_block

  routes = {
    igw_ipv6 = {
      destination_ipv6_cidr_block = "::/0"
      egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
    }
  }

  tags = local.tags
}
