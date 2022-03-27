provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
  name   = "vpc-flow-logs"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source = "../../../"

  name            = local.name
  ipv4_cidr_block = "10.10.0.0/16"

  # Not in v3.x
  enable_dnssec_config          = false
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false

  tags = local.tags
}

################################################################################
# VPC Flow Log
################################################################################

module "vpc_flow_log" {
  source = "../../../modules/flow-log"

  vpc_id = module.vpc.id

  create_cloudwatch_log_group            = true
  cloudwatch_log_group_name              = "/aws/vpc-flow-log/${module.vpc.id}"
  cloudwatch_log_group_retention_in_days = 0
  create_cloudwatch_iam_role             = true
  max_aggregation_interval               = 60

  tags = merge(local.tags, {
    Name = "vpc-flow-logs-cloudwatch-logs-default"
  })
}

################################################################################
# Subnets Module
################################################################################

module "public_subnets" {
  source = "../../../modules/subnet"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  map_public_ip_on_launch = true
  ipv4_cidr_block         = "10.10.101.0/24"
  availability_zone       = "${local.region}a"

  routes = {
    igw = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = module.vpc.internet_gateway_id
    }
  }

  tags = local.tags
}
