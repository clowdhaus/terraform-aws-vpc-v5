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
# VPC w/ Flow Logs to CloudWatch
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name = local.name
  cidr = "10.10.0.0/16"

  azs            = ["${local.region}a"]
  public_subnets = ["10.10.101.0/24"]

  # Cloudwatch log group and IAM role will be created
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  vpc_flow_log_tags = {
    Name = "vpc-flow-logs-cloudwatch-logs-default"
  }

  tags = local.tags
}
