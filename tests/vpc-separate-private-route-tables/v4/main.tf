provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
  name   = "vpc-ex-separate"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source = "../../../"

  name            = local.name
  ipv4_cidr_block = "10.10.0.0/16"

  # Not in v3.x
  enable_dnssec_config          = false
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false

  tags = local.tags
}

################################################################################
# Route Tables
################################################################################

module "public_route_table" {
  source = "../../../modules/route-table"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  routes = {
    igw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = module.vpc.internet_gateway_id
    }
  }

  tags = local.tags
}

module "private_route_table" {
  source = "../../../modules/route-table"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  routes = {
    nat_gw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.public_subnets.nat_gateways["${local.region}a"].id
    }
  }

  tags = local.tags
}

module "database_route_table" {
  source = "../../../modules/route-table"

  name   = "${local.name}-database"
  vpc_id = module.vpc.id

  tags = local.tags
}

module "elasticache_route_table" {
  source = "../../../modules/route-table"

  name   = "${local.name}-elasticache"
  vpc_id = module.vpc.id

  tags = local.tags
}

module "redshift_route_table" {
  source = "../../../modules/route-table"

  name   = "${local.name}-redshift"
  vpc_id = module.vpc.id

  tags = local.tags
}

################################################################################
# Subnets
################################################################################

module "public_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  subnets_default = {
    map_public_ip_on_launch = true
    route_table_id          = module.public_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block    = "10.10.11.0/24"
      availability_zone  = "${local.region}a"
      create_nat_gateway = true
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.10.12.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.10.13.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}

module "private_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  subnets_default = {
    route_table_id = module.private_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.10.1.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.10.2.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.10.3.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}

module "database_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-database"
  vpc_id = module.vpc.id

  subnets_default = {
    route_table_id = module.database_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.10.21.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.10.22.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.10.23.0/24"
      availability_zone = "${local.region}c"
    }
  }

  rds_subnet_groups = {
    database = {
      name                   = local.name
      description            = "Database subnet group for ${local.name}"
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]

      tags = {
        Name = local.name
      }
    }
  }

  tags = local.tags
}

module "elasticache_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-elasticache"
  vpc_id = module.vpc.id

  subnets_default = {
    route_table_id = module.elasticache_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.10.31.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.10.32.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.10.33.0/24"
      availability_zone = "${local.region}c"
    }
  }

  elasticache_subnet_groups = {
    elasticache = {
      name                   = local.name
      description            = "ElastiCache subnet group for ${local.name}"
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]

      tags = {
        Name = local.name
      }
    }
  }

  tags = local.tags
}

module "redshift_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-redshift"
  vpc_id = module.vpc.id

  subnets_default = {
    route_table_id = module.redshift_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.10.41.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.10.42.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.10.43.0/24"
      availability_zone = "${local.region}c"
    }
  }

  redshift_subnet_groups = {
    redshift = {
      name                   = local.name
      description            = "Redshift subnet group for ${local.name}"
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]

      tags = {
        Name = local.name
      }
    }
  }

  tags = local.tags
}
