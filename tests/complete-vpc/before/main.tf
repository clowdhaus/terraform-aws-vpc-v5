provider "aws" {
  region = "eu-west-1"
}

locals {
  name   = "complete-vpc"
  region = "eu-west-1"

  tags = {
    Owner       = "user"
    Environment = "staging"
  }
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0"

  name = local.name
  cidr = "172.16.0.0/16"

  azs                 = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets      = ["172.16.0.0/24", "172.16.1.0/24", "172.16.2.0/24"]
  private_subnets     = ["172.16.10.0/24", "172.16.11.0/24", "172.16.12.0/24"]
  database_subnets    = ["172.16.20.0/24", "172.16.21.0/24", "172.16.22.0/24"]
  elasticache_subnets = ["172.16.30.0/24", "172.16.31.0/24", "172.16.32.0/24"]
  redshift_subnets    = ["172.16.40.0/24", "172.16.41.0/24", "172.16.42.0/24"]
  intra_subnets       = ["172.16.50.0/24", "172.16.51.0/24", "172.16.52.0/24"]

  create_database_subnet_group = false

  manage_default_network_acl = true
  default_network_acl_tags   = { Name = "${local.name}-default" }

  manage_default_route_table = true
  default_route_table_tags   = { Name = "${local.name}-default" }

  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

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

  enable_vpn_gateway = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "172.16.0.2"]

  tags = local.tags
}
