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

  name                 = local.name
  cidr_block           = "10.99.0.0/16"
  enable_dns_hostnames = true
  vpc_tags             = { vpc_tags = true }

  ipv4_cidr_block_associations = {
    # This matches the provider API to avoid re-creating the association
    "10.98.0.0/16" = {
      cidr_block = "10.98.0.0/16"
      timeouts = {
        create = "12m"
        delete = "12m"
      }
    }
  }

  # DHCP
  create_dhcp_options              = true
  dhcp_options_domain_name         = "${local.region}.compute.internal"
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]
  dhcp_options_ntp_servers         = ["169.254.169.123"]
  dhcp_options_netbios_node_type   = 2
  dhcp_options_tags                = { dhcp_options_tags = true }

  tags = local.tags
}

module "public_subnets" {
  source = "../../modules/subnets"

  name   = "public"
  vpc_id = module.vpc.id

  subnets = {
    one = {
      cidr_block = "10.98.1.0/24"

      tags = { subnet_tags = true }
    }
  }

  tags = local.tags
}
