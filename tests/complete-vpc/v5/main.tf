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
  version = "5.0"

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

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  tags = local.tags
}

################################################################################
# VPC Endpoints
################################################################################

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.0"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.vpc_tls.id]
  subnet_ids         = module.vpc.private_subnets

  endpoints = {
    s3 = {
      service = "s3"
      tags    = { Name = "s3-vpc-endpoint" }
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      policy          = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
      tags            = { Name = "dynamodb-vpc-endpoint" }
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
    },
    lambda = {
      service             = "lambda"
      private_dns_enabled = true
    },
    ecs = {
      service             = "ecs"
      private_dns_enabled = true
    },
    ecs-telemetry = {
      service             = "ecs-telemetry"
      private_dns_enabled = true
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
    },
    kms = {
      service             = "kms"
      private_dns_enabled = true
    },
    codedeploy = {
      service             = "codedeploy"
      private_dns_enabled = true
    },
    codedeploy-commands-secure = {
      service             = "codedeploy-commands-secure"
      private_dns_enabled = true
    },
  }

  tags = merge(local.tags, {
    Project  = "Secret"
    Endpoint = "true"
  })
}

################################################################################
# Supporting Resources
################################################################################

data "aws_iam_policy_document" "dynamodb_endpoint_policy" {
  statement {
    effect    = "Deny"
    actions   = ["dynamodb:*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:sourceVpce"

      values = [module.vpc.vpc_id]
    }
  }
}

data "aws_iam_policy_document" "generic_endpoint_policy" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:SourceVpc"

      values = [module.vpc.vpc_id]
    }
  }
}

resource "aws_security_group" "vpc_tls" {
  name_prefix = "${local.name}-vpc_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = local.tags
}
