provider "aws" {
  region = "eu-west-1"
}

locals {
  name   = "complete-vpc"
  region = "eu-west-1"

  subnets = {
    "${local.region}a" = {
      public_ipv4_cidr_block      = "172.16.0.0/24"
      private_ipv4_cidr_block     = "172.16.10.0/24"
      database_ipv4_cidr_block    = "172.16.20.0/24"
      elasticache_ipv4_cidr_block = "172.16.30.0/24"
      redshift_ipv4_cidr_block    = "172.16.40.0/24"
      intra_ipv4_cidr_block       = "172.16.50.0/24"
    }
    "${local.region}b" = {
      public_ipv4_cidr_block      = "172.16.1.0/24"
      private_ipv4_cidr_block     = "172.16.11.0/24"
      database_ipv4_cidr_block    = "172.16.22.0/24"
      elasticache_ipv4_cidr_block = "172.16.31.0/24"
      redshift_ipv4_cidr_block    = "172.16.41.0/24"
      intra_ipv4_cidr_block       = "172.16.51.0/24"
    }
    "${local.region}c" = {
      public_ipv4_cidr_block      = "172.16.2.0/24"
      private_ipv4_cidr_block     = "172.16.12.0/24"
      database_ipv4_cidr_block    = "172.16.22.0/24"
      elasticache_ipv4_cidr_block = "172.16.32.0/24"
      redshift_ipv4_cidr_block    = "172.16.42.0/24"
      intra_ipv4_cidr_block       = "172.16.52.0/24"
    }
  }

  tags = {
    Owner       = "user"
    Environment = "staging"
  }
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source = "../../../"

  name            = local.name
  ipv4_cidr_block = "172.16.0.0/16"

  # Not in v4.x
  enable_dnssec_config = false

  manage_default_route_table    = true
  manage_default_security_group = true
  manage_default_network_acl    = true
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

  customer_gateways = {
    IP1 = {
      bgp_asn     = 65112
      ip_address  = "1.2.3.4"
      device_name = "some_name"
    },
    IP2 = {
      bgp_asn    = 65112
      ip_address = "5.6.7.8"
    }
  }

  vpn_gateways = {
    one = {}
  }

  dhcp_options = {
    domain_name         = "service.consul"
    domain_name_servers = ["127.0.0.1", "172.16.0.2"]
  }

  tags = local.tags
}

################################################################################
# Subnet
################################################################################

module "public_subnet" {
  source = "../../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-public-${each.key}"
  vpc_id = module.vpc.id

  availability_zone       = each.key
  map_public_ip_on_launch = true
  ipv4_cidr_block         = each.value.public_ipv4_cidr_block

  # Just create one NAT Gateway
  create_nat_gateway = each.key == "${local.region}a"

  routes = {
    igw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
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
    nat_gw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.public_subnet["${local.region}a"].nat_gateway_id
    }
  }

  tags = local.tags
}

module "database_subnet" {
  source = "../../../modules/subnet"

  name   = "${local.name}-database-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.database_ipv4_cidr_block

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

module "redshift_subnet" {
  source = "../../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-redshift-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.redshift_ipv4_cidr_block

  tags = local.tags
}

module "intra_subnet" {
  source = "../../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-intra-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.intra_ipv4_cidr_block

  tags = local.tags
}
