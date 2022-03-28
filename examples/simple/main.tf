provider "aws" {
  region = local.region
}

locals {
  name   = "vpc-ex-${replace(basename(path.cwd), "_", "-")}"
  region = "eu-west-1"

  subnets = {
    "${local.region}a" = {
      public_ipv4_cidr_block  = "10.0.0.0/24"
      private_ipv4_cidr_block = "10.0.10.0/24"
    }
    "${local.region}b" = {
      public_ipv4_cidr_block  = "10.0.1.0/24"
      private_ipv4_cidr_block = "10.0.11.0/24"
    }
    "${local.region}c" = {
      public_ipv4_cidr_block  = "10.0.2.0/24"
      private_ipv4_cidr_block = "10.0.12.0/24"
    }
  }

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

  # Faster deploy
  enable_dnssec_config = false

  create_egress_only_internet_gateway = true

  tags = local.tags
}

################################################################################
# Subnets
################################################################################

module "public_subnet" {
  source = "../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-public-${each.key}"
  vpc_id = module.vpc.id

  availability_zone       = each.key
  map_public_ip_on_launch = true
  ipv4_cidr_block         = each.value.public_ipv4_cidr_block

  # Just create one NAT Gateway
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

  for_each = local.subnets

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.private_ipv4_cidr_block

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
