provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
  name   = "network-acls"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  network_acls = {

    default_inbound = {
      900 = {
        rule_action     = "allow"
        from_port       = 1024
        to_port         = 65535
        protocol        = "tcp"
        ipv4_cidr_block = "0.0.0.0/0"
      },
    }

    default_outbound = {
      900 = {
        rule_number     = 900
        rule_action     = "allow"
        from_port       = 32768
        to_port         = 65535
        protocol        = "tcp"
        ipv4_cidr_block = "0.0.0.0/0"
      },
    }

    public_inbound = {
      100 = {
        rule_action     = "allow"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        ipv4_cidr_block = "0.0.0.0/0"
      },
      110 = {
        rule_action     = "allow"
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        ipv4_cidr_block = "0.0.0.0/0"
      },
      120 = {
        rule_action     = "allow"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        ipv4_cidr_block = "0.0.0.0/0"
      },
      130 = {
        rule_action     = "allow"
        from_port       = 3389
        to_port         = 3389
        protocol        = "tcp"
        ipv4_cidr_block = "0.0.0.0/0"
      },
      140 = {
        rule_action     = "allow"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
    }

    public_outbound = {
      100 = {
        rule_action     = "allow"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        ipv4_cidr_block = "0.0.0.0/0"
      },
      110 = {
        rule_action     = "allow"
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        ipv4_cidr_block = "0.0.0.0/0"
      },
      120 = {
        rule_action     = "allow"
        from_port       = 1433
        to_port         = 1433
        protocol        = "tcp"
        ipv4_cidr_block = "10.0.100.0/22"
      },
      130 = {
        rule_action     = "allow"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        ipv4_cidr_block = "10.0.100.0/22"
      },
      140 = {
        rule_action     = "allow"
        icmp_code       = -1
        icmp_type       = 8
        protocol        = "icmp"
        ipv4_cidr_block = "10.0.0.0/22"
      },
      150 = {
        rule_action     = "allow"
        from_port       = 90
        to_port         = 90
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
    }

    elasticache_outbound = {
      100 = {
        rule_action     = "allow"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        ipv4_cidr_block = "0.0.0.0/0"
      },
      110 = {
        rule_action     = "allow"
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        ipv4_cidr_block = "0.0.0.0/0"
      },
      140 = {
        rule_action     = "allow"
        icmp_code       = -1
        icmp_type       = 12
        protocol        = "icmp"
        ipv4_cidr_block = "10.0.0.0/22"
      },
      150 = {
        rule_action     = "allow"
        from_port       = 90
        to_port         = 90
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
    }
  }
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source = "../../../"

  name            = local.name
  ipv4_cidr_block = "10.0.0.0/16"

  # Not in v3.x
  enable_dnssec_config = false

  # IPv6
  assign_generated_ipv6_cidr_block    = true
  create_egress_only_internet_gateway = true

  # Default resources
  default_network_acl_ingress_rules = {
    100 = {
      rule_action     = "allow"
      from_port       = 0
      protocol        = "-1"
      to_port         = 0
      ipv4_cidr_block = "0.0.0.0/0"
    }
    101 = {
      rule_action     = "allow"
      from_port       = 0
      protocol        = "-1"
      to_port         = 0
      ipv6_cidr_block = "::/0"
    }
  }
  default_network_acl_egress_rules = {
    100 = {
      rule_action     = "allow"
      from_port       = 0
      protocol        = "-1"
      to_port         = 0
      ipv4_cidr_block = "0.0.0.0/0"
    }
    101 = {
      rule_action     = "allow"
      from_port       = 0
      protocol        = "-1"
      to_port         = 0
      ipv6_cidr_block = "::/0"
    }
  }

  default_network_acl_tags = {
    Name = local.name
  }

  tags = local.tags

  vpc_tags = {
    Name = "vpc-name"
  }
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
    igw_ipv6 = {
      destination_ipv6_cidr_block = "::/0"
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
    eigw_ipv6 = {
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
  source = "../../../modules/subnets"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  subnets_default = {
    map_public_ip_on_launch = true
    route_table_id          = module.public_route_table.id
    tags = {
      Name = "overridden-name-public"
    }
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.0.101.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.102.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.0.103.0/24"
      availability_zone = "${local.region}c"
    }
  }

  network_acl_ingress_rules = merge(local.network_acls.default_inbound, local.network_acls.public_inbound)
  network_acl_egress_rules  = merge(local.network_acls.default_outbound, local.network_acls.public_outbound)

  tags = local.tags
}

module "private_subnets" {
  source = "../../../modules/subnets"

  name               = "${local.name}-private"
  vpc_id             = module.vpc.id
  create_network_acl = false

  subnets_default = {
    route_table_id = module.private_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.0.1.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.2.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.0.3.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}

module "elasticache_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-elasticache"
  vpc_id = module.vpc.id

  subnets_default = {
    route_table_id = module.private_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.0.201.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.202.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.0.203.0/24"
      availability_zone = "${local.region}c"
    }
  }

  elasticache_subnet_groups = {
    elasticache = {
      name                   = local.name
      description            = "ElastiCache subnet group for ${local.name}"
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]
    }
  }

  network_acl_ingress_rules = {
    100 = {
      rule_action     = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv4_cidr_block = "0.0.0.0/0"
    }
  }
  network_acl_egress_rules = merge(local.network_acls.default_outbound, local.network_acls.elasticache_outbound)

  tags = local.tags
}
