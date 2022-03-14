provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
  name   = "ipv6"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  ipv6_cidr_subnets = cidrsubnets(module.vpc.ipv6_cidr_block, 8, 8, 8, 8, 8, 8)
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../../"

  name            = local.name
  ipv4_cidr_block = "10.0.0.0/16"

  # Not in v3.x
  enable_dnssec_config          = false
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false

  assign_generated_ipv6_cidr_block    = true
  create_egress_only_internet_gateway = true

  tags = local.tags
}

module "public_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

  subnets_default = {
    assign_ipv6_address_on_creation = true
    map_public_ip_on_launch         = true
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.0.101.0/24"
      ipv6_cidr_block   = element(local.ipv6_cidr_subnets, 0)
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.102.0/24"
      ipv6_cidr_block   = element(local.ipv6_cidr_subnets, 1)
      availability_zone = "${local.region}b"
    }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b"]
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
  source = "../../../modules/subnets"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.0.1.0/24"
      ipv6_cidr_block   = element(local.ipv6_cidr_subnets, 2)
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.2.0/24"
      ipv6_cidr_block   = element(local.ipv6_cidr_subnets, 3)
      availability_zone = "${local.region}b"
    }
  }

  route_tables = {
    "${local.region}a" = {
      associated_subnet_keys = ["${local.region}a"]
      routes = {
        eigw_ipv6 = {
          destination_ipv6_cidr_block = "::/0"
          egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
        }
      }
    }
    "${local.region}b" = {
      associated_subnet_keys = ["${local.region}b"]
      routes = {
        eigw_ipv6 = {
          destination_ipv6_cidr_block = "::/0"
          egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
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

  # Backwards compat
  create_network_acl = false

  subnets_default = {
    assign_ipv6_address_on_creation = true
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.0.103.0/24"
      ipv6_cidr_block   = element(local.ipv6_cidr_subnets, 4)
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.104.0/24"
      ipv6_cidr_block   = element(local.ipv6_cidr_subnets, 5)
      availability_zone = "${local.region}b"
    }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b"]
      routes = {
        igw_ipv4 = {
          destination_ipv4_cidr_block = "0.0.0.0/0"
          gateway_id                  = module.vpc.internet_gateway_id
        }
        eigw_ipv6 = {
          destination_ipv6_cidr_block = "::/0"
          egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
        }
      }
    }
  }

  rds_subnet_groups = {
    database = {
      name                   = local.name
      description            = "Database subnet group for ${local.name}"
      associated_subnet_keys = ["${local.region}a", "${local.region}b"]

      tags = {
        Name = local.name
      }
    }
  }

  tags = local.tags
}
