provider "aws" {
  region = local.region
}

# Used to aid in diffing across v3/v4 in separate folders
terraform {
  backend "s3" {
    bucket = "terraform-aws-vpc-v4"
    key    = "simple-vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

locals {
  name   = "simple-example"
  cidr   = "10.0.0.0/16"
  region = "eu-west-1"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../../"

  name       = local.name
  cidr_block = local.cidr

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

module "public_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

  subnets = {
    "${local.region}a" = {
      cidr_block              = "10.0.101.0/24"
      availability_zone       = "${local.region}a"
      map_public_ip_on_launch = true
      tags = {
        Name = "overridden-name-public"
      }
    }
    "${local.region}b" = {
      cidr_block              = "10.0.102.0/24"
      availability_zone       = "${local.region}b"
      map_public_ip_on_launch = true
      tags = {
        Name = "overridden-name-public"
      }
    }
    "${local.region}c" = {
      cidr_block              = "10.0.103.0/24"
      availability_zone       = "${local.region}c"
      map_public_ip_on_launch = true
      tags = {
        Name = "overridden-name-public"
      }
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

      tags = {
        Name = "simple-example-public"
      }
    }
  }

  tags = merge(local.tags, {
    Name = "overridden-name-public"
  })
}


module "private_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

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
        igw_ipv6 = {
          destination_ipv6_cidr_block = "::/0"
          egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
        }
      }

      tags = {
        Name = "simple-example-private"
      }
    }
  }

  tags = local.tags
}
