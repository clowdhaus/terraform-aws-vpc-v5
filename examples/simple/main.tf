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

  name       = local.name
  cidr_block = "10.0.0.0/16"

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

  subnets = {
    "${local.region}a" = {
      cidr_block              = "10.0.101.0/24"
      availability_zone       = "${local.region}a"
      map_public_ip_on_launch = true
      create_nat_gateway      = true
    }
    "${local.region}b" = {
      cidr_block              = "10.0.102.0/24"
      availability_zone       = "${local.region}b"
      map_public_ip_on_launch = true
    }
    "${local.region}c" = {
      cidr_block              = "10.0.103.0/24"
      availability_zone       = "${local.region}c"
      map_public_ip_on_launch = true
    }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]
      routes = {
        igw_ipv4 = {
          destination_cidr_block = "0.0.0.0/0"
          gateway_id             = module.vpc.internet_gateway_id
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
      cidr_block        = "10.0.1.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "${local.region}c"
    }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]
      routes = {
        igw_ipv4 = {
          destination_cidr_block = "0.0.0.0/0"
          nat_gateway_id         = module.public_subnets.nat_gateways["${local.region}a"].id
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
