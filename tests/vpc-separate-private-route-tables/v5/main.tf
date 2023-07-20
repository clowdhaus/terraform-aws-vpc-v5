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
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0"

  name = local.name
  cidr = "10.10.0.0/16"

  azs                 = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets      = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnets     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  database_subnets    = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  elasticache_subnets = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
  redshift_subnets    = ["10.0.40.0/24", "10.0.41.0/24", "10.0.42.0/24"]

  create_database_subnet_route_table    = true
  create_elasticache_subnet_route_table = true
  create_redshift_subnet_route_table    = true

  single_nat_gateway = true
  enable_nat_gateway = true

  tags = local.tags
}
