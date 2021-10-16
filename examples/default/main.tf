provider "aws" {
  region = local.region
}

locals {
  name        = "default-example"
  cidr_prefix = "10.0"
  region      = "eu-west-1"
  tags = {
    Owner       = "user"
    Environment = "staging"
    Name        = "default"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../"

  name       = local.name
  cidr_block = "${local.cidr_prefix}.0.0/16"

  tags = local.tags
}
