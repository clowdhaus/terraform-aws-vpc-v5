provider "aws" {
  region = local.region
}

locals {
  name        = "example-${replace(basename(path.cwd), "_", "-")}"
  cidr_prefix = "10.99"
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

  name            = local.name
  ipv4_cidr_block = "${local.cidr_prefix}.0.0/16"

  tags = local.tags
}
