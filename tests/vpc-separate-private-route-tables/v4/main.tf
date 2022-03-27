provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
  name   = "vpc-ex-separate"

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

  # Not in v3.x
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

  for_each = {
    "${local.region}a" = {
      ipv4_cidr_block = "10.10.11.0/24"
    }
    "${local.region}b" = {
      ipv4_cidr_block = "10.10.12.0/24"
    }
    "${local.region}c" = {
      ipv4_cidr_block = "10.10.13.0/24"
    }
  }

  name   = "${local.name}-public-${each.key}"
  vpc_id = module.vpc.id

  availability_zone       = each.key
  map_public_ip_on_launch = true
  ipv4_cidr_block         = each.value.ipv4_cidr_block

  # Just create onc NAT Gateway
  create_nat_gateway = each.key == "${local.region}a"

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

  for_each = {
    "${local.region}a" = {
      ipv4_cidr_block = "10.10.1.0/24"
    }
    "${local.region}b" = {
      ipv4_cidr_block = "10.10.2.0/24"
    }
    "${local.region}c" = {
      ipv4_cidr_block = "10.10.3.0/24"
    }
  }

  name   = "${local.name}-private-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.ipv4_cidr_block

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

  for_each = {
    "${local.region}a" = {
      ipv4_cidr_block = "10.10.21.0/24"
    }
    "${local.region}b" = {
      ipv4_cidr_block = "10.10.22.0/24"
    }
    "${local.region}c" = {
      ipv4_cidr_block = "10.10.23.0/24"
    }
  }

  name   = "${local.name}-database-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.ipv4_cidr_block

  tags = local.tags
}

module "elasticache_subnet" {
  source = "../../../modules/subnet"

  for_each = {
    "${local.region}a" = {
      ipv4_cidr_block = "10.10.31.0/24"
    }
    "${local.region}b" = {
      ipv4_cidr_block = "10.10.32.0/24"
    }
    "${local.region}c" = {
      ipv4_cidr_block = "10.10.33.0/24"
    }
  }

  name   = "${local.name}-elasticache-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.ipv4_cidr_block

  tags = local.tags
}

module "redshift_subnet" {
  source = "../../../modules/subnet"

  for_each = {
    "${local.region}a" = {
      ipv4_cidr_block = "10.10.41.0/24"
    }
    "${local.region}b" = {
      ipv4_cidr_block = "10.10.42.0/24"
    }
    "${local.region}c" = {
      ipv4_cidr_block = "10.10.43.0/24"
    }
  }

  name   = "${local.name}-redshift-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.ipv4_cidr_block

  tags = local.tags
}
