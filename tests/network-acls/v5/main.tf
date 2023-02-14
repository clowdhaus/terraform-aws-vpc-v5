provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
  name   = "network-acls"

  subnets = {
    "${local.region}a" = {
      public_ipv4_cidr_block      = "10.0.0.0/24"
      private_ipv4_cidr_block     = "10.0.10.0/24"
      elasticache_ipv4_cidr_block = "10.0.20.0/24"
    }
    "${local.region}b" = {
      public_ipv4_cidr_block      = "10.0.1.0/24"
      private_ipv4_cidr_block     = "10.0.11.0/24"
      elasticache_ipv4_cidr_block = "10.0.21.0/24"
    }
    "${local.region}c" = {
      public_ipv4_cidr_block      = "10.0.2.0/24"
      private_ipv4_cidr_block     = "10.0.12.0/24"
      elasticache_ipv4_cidr_block = "10.0.22.0/24"
    }
  }

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

  # Not in v4.x
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
# Subnets
################################################################################

module "public_subnet" {
  source = "../../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-public-${each.key}"
  vpc_id = module.vpc.id

  availability_zone       = each.key
  map_public_ip_on_launch = true
  ipv4_cidr_block         = each.value.public_ipv4_cidr_block

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

module "private_subnet" {
  source = "../../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-private-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.private_ipv4_cidr_block

  routes = {
    eigw_ipv6 = {
      destination_ipv6_cidr_block = "::/0"
      egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
    }
  }

  tags = local.tags
}

module "elasticache_subnet" {
  source = "../../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-elasticache-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.elasticache_ipv4_cidr_block

  tags = local.tags
}

################################################################################
# Network ACL
################################################################################

module "public_network_acl" {
  source = "../../../modules/network-acl"

  vpc_id     = module.vpc.id
  subnet_ids = [for subnet in module.public_subnet : subnet.id]

  ingress_rules = merge(local.network_acls.default_inbound, local.network_acls.public_inbound)
  egress_rules  = merge(local.network_acls.default_outbound, local.network_acls.public_outbound)

  tags = local.tags
}

module "elasticache_network_acl" {
  source = "../../../modules/network-acl"

  vpc_id     = module.vpc.id
  subnet_ids = [for subnet in module.elasticache_subnet : subnet.id]

  ingress_rules = {
    100 = {
      rule_action     = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv4_cidr_block = "0.0.0.0/0"
    }
  }
  egress_rules = merge(local.network_acls.default_outbound, local.network_acls.elasticache_outbound)

  tags = local.tags
}
