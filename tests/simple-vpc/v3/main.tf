provider "aws" {
  region = local.region
}

# Used to aid in diffing across v3/v4 in separate folders
terraform {
  backend "s3" {
    bucket = "terraform-aws-vpc-v4"
    key    = "simple-vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

locals {
  name   = "simple-example"
  cidr   = "10.0.0.0/16"
  region = "eu-west-1"

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
  version = "3.12.0"

  name = local.name
  cidr = local.cidr

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = false
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  vpc_tags = {
    Name = "vpc-name"
  }

  tags = local.tags
}
