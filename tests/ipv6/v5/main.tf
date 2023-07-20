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
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0"

  name = local.name
  cidr = "10.0.0.0/16"

  azs              = ["${local.region}a", "${local.region}b"]
  private_subnets  = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets   = ["10.0.10.0/24", "10.0.11.0/24"]
  database_subnets = ["10.0.20.0/24", "10.0.12.0/24"]

  public_subnet_ipv6_prefixes                     = [0, 1, 2]
  public_subnet_assign_ipv6_address_on_creation   = true
  private_subnet_ipv6_prefixes                    = [3, 4, 5]
  private_subnet_assign_ipv6_address_on_creation  = true
  database_subnet_ipv6_prefixes                   = [6, 7, 8]
  database_subnet_assign_ipv6_address_on_creation = true

  enable_nat_gateway     = false
  enable_ipv6            = true
  create_egress_only_igw = true

  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  tags = local.tags
}
