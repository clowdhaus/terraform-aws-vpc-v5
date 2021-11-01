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
  azs = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnet_cidrs = concat(
    [for sub in [11, 12, 13] : "${local.cidr_prefix}.${sub}.0/24"],
    [for sub2 in [11, 12, 13] : "${local.cidr_prefix_2}.${sub2}.0/24"],
  )
  private_subnet_cidrs = concat(
    [for sub in [8, 9, 10] : "${local.cidr_prefix}.${sub}.0/24"],
    [for sub2 in [8, 9, 10] : "${local.cidr_prefix_2}.${sub2}.0/24"],
  )

  public_subnets = { for sub in range(length(local.public_subnet_cidrs)) :
    "public-${sub}" => {
      route_table_key   = "public"
      availability_zone = element(local.azs, sub)
      cidr_block        = element(local.public_subnet_cidrs, sub)
    }
  }

  private_subnets = { for sub in range(length(local.private_subnet_cidrs)) :
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
    public  = {}
    private = {}
  }

  create_igw = true
  igw_routes = {
    public = {
      route_table_key = "public"
    }
    private = {
      route_table_key        = "private"
      destination_cidr_block = "10.13.0.0/16"
    }
  }

  manage_default_network_acl = true
  network_acls = {
    private = {
      subnet_keys = keys(local.private_subnets)
    }
    public = {
      subnet_keys = keys(local.public_subnets)
    }
  }
  network_acl_rules = {
    allow_all_outbound = {
      network_acl_key = "private"
      rule_number     = 10
      egress          = true
      protocol        = "-1"
      rule_action     = "allow"
      cidr_block      = "0.0.0.0/0"
    }
    block_inbound_ssh = {
      network_acl_key = "public"
      rule_number     = 10
      egress          = false
      protocol        = "tcp"
      rule_action     = "deny"
      cidr_block      = "0.0.0.0/0"
      from_port       = 22
      to_port         = 22
    }
  }

  tags = local.tags
}
