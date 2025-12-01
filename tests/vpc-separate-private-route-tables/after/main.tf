provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
  name   = "vpc-ex-separate"

  subnets = {
    "${local.region}a" = {
      public_ipv4_cidr_block      = "172.16.0.0/24"
      private_ipv4_cidr_block     = "172.16.10.0/24"
      database_ipv4_cidr_block    = "172.16.20.0/24"
      elasticache_ipv4_cidr_block = "172.16.30.0/24"
      redshift_ipv4_cidr_block    = "172.16.40.0/24"
    }
    "${local.region}b" = {
      public_ipv4_cidr_block      = "172.16.1.0/24"
      private_ipv4_cidr_block     = "172.16.11.0/24"
      database_ipv4_cidr_block    = "172.16.22.0/24"
      elasticache_ipv4_cidr_block = "172.16.31.0/24"
      redshift_ipv4_cidr_block    = "172.16.41.0/24"
    }
    "${local.region}c" = {
      public_ipv4_cidr_block      = "172.16.2.0/24"
      private_ipv4_cidr_block     = "172.16.12.0/24"
      database_ipv4_cidr_block    = "172.16.22.0/24"
      elasticache_ipv4_cidr_block = "172.16.32.0/24"
      redshift_ipv4_cidr_block    = "172.16.42.0/24"
    }
  }

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
  ipv4_cidr_block = "10.10.0.0/16"

  # Not in v4.x
  enable_dnssec_config          = false
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false

  tags = local.tags
}

################################################################################
# Subnets
################################################################################

module "public_subnet" {
  source = "../../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-public-${each.key}"
  vpc_id = module.vpc.id

  availability_zone       = each.key
  map_public_ip_on_launch = true
  ipv4_cidr_block         = each.value.public_ipv4_cidr_block

  # Just create one NAT Gateway
  # THIS IS WRONG DUMMY!!!2/3 AZs do not have routes to this
  # nat_gateway = each.key == "${local.region}a"

  routes = {
    igw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = module.vpc.internet_gateway_id
    }
  }

  tags = local.tags
}

module "private_subnet" {
  source = "../../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-private-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.private_ipv4_cidr_block

  routes = {
    nat_gw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.public_subnet["${local.region}a"].nat_gateway_id
    }
  }

  tags = local.tags
}

module "database_subnet" {
  source = "../../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-database-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.database_ipv4_cidr_block

  tags = local.tags
}

module "elasticache_subnet" {
  source = "../../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-elasticache-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.elasticache_ipv4_cidr_block

  tags = local.tags
}

module "redshift_subnet" {
  source = "../../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-redshift-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.redshift_ipv4_cidr_block

  tags = local.tags
}
