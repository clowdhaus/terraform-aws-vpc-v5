provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
  name   = "vpc-ex-${replace(basename(path.cwd), "_", "-")}"

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
  cidr_block = "10.10.0.0/16"

  # Not in v3.x
  enable_dnssec_config          = false
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false

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
      cidr_block              = "10.10.11.0/24"
      availability_zone       = "${local.region}a"
      map_public_ip_on_launch = true
      create_nat_gateway      = true
    }
    "${local.region}b" = {
      cidr_block              = "10.10.12.0/24"
      availability_zone       = "${local.region}b"
      map_public_ip_on_launch = true
    }
    "${local.region}c" = {
      cidr_block              = "10.10.13.0/24"
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
      }
    }
  }

  tags = local.tags
}

module "private_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  subnets = {
    "${local.region}a" = {
      cidr_block        = "10.10.1.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      cidr_block        = "10.10.2.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      cidr_block        = "10.10.3.0/24"
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
      }
    }
  }

  tags = local.tags
}

module "database_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-database"
  vpc_id = module.vpc.id

  subnets = {
    "${local.region}a" = {
      cidr_block        = "10.10.21.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      cidr_block        = "10.10.22.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      cidr_block        = "10.10.23.0/24"
      availability_zone = "${local.region}c"
    }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]
    }
  }

  tags = local.tags
}

module "elasticache_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-elasticache"
  vpc_id = module.vpc.id

  subnets = {
    "${local.region}a" = {
      cidr_block        = "10.10.31.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      cidr_block        = "10.10.32.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      cidr_block        = "10.10.33.0/24"
      availability_zone = "${local.region}c"
    }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]
    }
  }

  tags = local.tags
}

module "redshift_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-redshift"
  vpc_id = module.vpc.id

  subnets = {
    "${local.region}a" = {
      cidr_block        = "10.10.41.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      cidr_block        = "10.10.42.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      cidr_block        = "10.10.43.0/24"
      availability_zone = "${local.region}c"
    }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]
    }
  }

  tags = local.tags
}