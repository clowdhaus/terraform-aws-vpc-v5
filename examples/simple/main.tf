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

  vpc_tags = {
    vpc_tag = true
  }

  tags = local.tags
}

################################################################################
# Route Tables
################################################################################

module "public_route_table" {
  source = "../../modules/route-table"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

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


module "private_route_table" {
  source = "../../modules/route-table"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  routes = {
    igw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.public_subnets.nat_gateways["${local.region}a"].id
    }
    igw_ipv6 = {
      destination_ipv6_cidr_block = "::/0"
      egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
    }
  }

  tags = local.tags
}

################################################################################
# Subnets
################################################################################

module "public_subnets" {
  source = "../../modules/subnets"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  subnets_default = {
    map_public_ip_on_launch = true
    route_table_id          = module.public_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block    = "10.0.100.0/24"
      availability_zone  = "${local.region}a"
      create_nat_gateway = true
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.101.0/24"
      availability_zone = "${local.region}b"
    }
    "three" = {
      ipv4_cidr_block   = "10.0.102.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}


module "private_subnets" {
  source = "../../modules/subnets"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  subnets_default = {
    map_public_ip_on_launch = true
    route_table_id          = module.private_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.0.10.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.11.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.0.12.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}
