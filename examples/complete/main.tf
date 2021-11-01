provider "aws" {
  region = local.region
}

locals {
  name          = "example-${replace(basename(path.cwd), "_", "-")}"
  cidr_prefix   = "10.99"
  cidr_prefix_2 = "10.98"
  region        = "eu-west-1"
  tags = {
    Owner       = "user"
    Environment = "staging"
  }
}

################################################################################
# VPC Module
################################################################################

locals {
  azs                  = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnet_cidrs  = [for sub in [11, 12, 13] : "${local.cidr_prefix}.${sub}.0/24"]
  private_subnet_cidrs = [for sub in [8, 9, 10] : "${local.cidr_prefix}.${sub}.0/24"]

  public_subnets = { for sub in range(3) :
    "public-${sub}" => {
      route_table_key   = "public"
      availability_zone = element(local.azs, sub)
      cidr_block        = element(local.public_subnet_cidrs, sub)
    }
  }

  private_subnets = { for sub in range(3) :
    "private-${sub}" => {
      route_table_key   = "private"
      availability_zone = element(local.azs, sub)
      cidr_block        = element(local.private_subnet_cidrs, sub)
    }
  }
}

module "vpc" {
  source = "../../"

  name                  = local.name
  cidr_block            = "${local.cidr_prefix}.0.0/16"
  secondary_cidr_blocks = ["${local.cidr_prefix_2}.0.0/16"]

  manage_default_security_group = true

  subnets = merge(
    local.public_subnets,
    local.private_subnets,
  )

  manage_default_route_table = true
  route_tables = {
    public = {
      route = []
    }
    private = {
      route = []
    }
  }

  manage_default_network_acl = true

  tags = local.tags
}
