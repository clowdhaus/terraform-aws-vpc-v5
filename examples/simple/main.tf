provider "aws" {
  region = local.region
}

locals {
  name   = "vpc-ex-${replace(basename(path.cwd), "_", "-")}"
  region = "eu-west-1"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc-v4"
  }
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source = "../../"

  name            = local.name
  ipv4_cidr_block = "10.0.0.0/16"

  # Faster
  enable_dnssec_config = false

  create_egress_only_internet_gateway = true

  tags = local.tags
}

################################################################################
# Subnets
################################################################################

module "public_subnet" {
  source = "../../modules/subnet"

  for_each = {
    "${local.region}a" = {
      ipv4_cidr_block = "10.0.100.0/24"
    }
    "${local.region}b" = {
      ipv4_cidr_block = "10.0.101.0/24"
    }
    "${local.region}c" = {
      ipv4_cidr_block = "10.0.102.0/24"
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
    igw_ipv6 = {
      destination_ipv6_cidr_block = "::/0"
      gateway_id                  = module.vpc.internet_gateway_id
    }
  }

  tags = local.tags
}

module "private_subnet" {
  source = "../../modules/subnet"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  for_each = {
    "${local.region}a" = {
      ipv4_cidr_block = "10.0.10.0/24"
    }
    "${local.region}b" = {
      ipv4_cidr_block = "10.0.11.0/24"
    }
    "${local.region}c" = {
      ipv4_cidr_block = "10.0.12.0/24"
    }
  }

  routes = {
    igw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.public_subnet["${local.region}a"].nat_gateway_id
    }
    igw_ipv6 = {
      destination_ipv6_cidr_block = "::/0"
      egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
    }
  }

  tags = local.tags
}
