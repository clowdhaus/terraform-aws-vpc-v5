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
# VPC Module
################################################################################

module "vpc" {
  source = "../../"

  name            = local.name
  ipv4_cidr_block = "10.0.0.0/16"

  # Faster
  enable_dnssec_config = false

  assign_generated_ipv6_cidr_block    = true
  create_egress_only_internet_gateway = true

  vpc_tags = {
    vpc_tag = true
  }

  tags = local.tags
}

module "public_subnets" {
  source = "../../modules/subnets"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  subnets_default = {
    map_public_ip_on_launch = true
  }

  subnets = {
    "one" = {
      ipv4_cidr_block    = "10.0.100.0/24"
      availability_zone  = "${local.region}a"
      create_nat_gateway = true
    }
    "two" = {
      ipv4_cidr_block   = "10.0.101.0/24"
      availability_zone = "${local.region}b"
    }
    "three" = {
      ipv4_cidr_block   = "10.0.102.0/24"
      availability_zone = "${local.region}c"
    }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["one", "two", "three"]
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
    }
  }

  tags = local.tags
}


module "private_subnets" {
  source = "../../modules/subnets"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

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

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]
      routes = {
        igw_ipv4 = {
          destination_ipv4_cidr_block = "0.0.0.0/0"
          nat_gateway_id              = module.public_subnets.nat_gateways["one"].id
        }
        igw_ipv6 = {
          destination_ipv6_cidr_block = "::/0"
          egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
        }
      }
    }
  }

  tags = local.tags
}
