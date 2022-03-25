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
  source = "../../../"

  name            = local.name
  ipv4_cidr_block = "172.16.0.0/16" # 10.0.0.0/8 is reserved for EC2-Classic

  # Not in v3.x
  enable_dnssec_config = false

  manage_default_network_acl = true
  default_network_acl_tags   = { Name = "${local.name}-default" }
  default_network_acl_ingress_rules = {
    100 = {
      rule_action     = "allow"
      from_port       = 0
      protocol        = "-1"
      to_port         = 0
      ipv4_cidr_block = "0.0.0.0/0"
    }
    101 = {
      rule_action     = "allow"
      from_port       = 0
      protocol        = "-1"
      to_port         = 0
      ipv6_cidr_block = "::/0"
    }
  }
  default_network_acl_egress_rules = {
    100 = {
      rule_action     = "allow"
      from_port       = 0
      protocol        = "-1"
      to_port         = 0
      ipv4_cidr_block = "0.0.0.0/0"
    }
    101 = {
      rule_action     = "allow"
      from_port       = 0
      protocol        = "-1"
      to_port         = 0
      ipv6_cidr_block = "::/0"
    }
  }

  manage_default_route_table = true
  default_route_table_tags   = { Name = "${local.name}-default" }

  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }

  enable_classiclink             = true
  enable_classiclink_dns_support = true

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

  vpn_gateways = {
    one = {}
  }

  create_dhcp_options              = true
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "172.16.0.2"]

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

  tags = local.tags
}

################################################################################
# Route Tables
################################################################################

module "public_route_table" {
  source = "../../../modules/route-table"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  routes = {
    igw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = module.vpc.internet_gateway_id
    }
  }

  tags = local.tags
}

module "private_route_table" {
  source = "../../../modules/route-table"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  routes = {
    nat_gw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      nat_gateway_id              = module.public_subnets.nat_gateways["${local.region}a"].id
    }
  }

  tags = local.tags
}

module "intra_route_table" {
  source = "../../../modules/route-table"

  name   = "${local.name}-intra"
  vpc_id = module.vpc.id

  tags = local.tags
}

################################################################################
# Subnets
################################################################################

module "public_subnets" {
  source = "../../../modules/subnet"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  subnets_default = {
    map_public_ip_on_launch = true
    route_table_id          = module.public_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block    = "172.16.11.0/24"
      availability_zone  = "${local.region}a"
      create_nat_gateway = true
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "172.16.12.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "172.16.13.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}

module "private_subnets" {
  source = "../../../modules/subnet"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  subnets_default = {
    route_table_id = module.private_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "172.16.1.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "172.16.2.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "172.16.3.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}

module "database_subnets" {
  source = "../../../modules/subnet"

  name   = "${local.name}-database"
  vpc_id = module.vpc.id

  subnets_default = {
    route_table_id = module.private_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "172.16.21.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "172.16.22.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "172.16.23.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}

module "elasticache_subnets" {
  source = "../../../modules/subnet"

  name   = "${local.name}-elasticache"
  vpc_id = module.vpc.id

  subnets_default = {
    route_table_id = module.private_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "172.16.31.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "172.16.32.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "172.16.33.0/24"
      availability_zone = "${local.region}c"
    }
  }

  elasticache_subnet_groups = {
    elasticache = {
      name                   = local.name
      description            = "ElastiCache subnet group for ${local.name}"
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]

      tags = {
        Name = local.name
      }
    }
  }

  tags = local.tags
}

module "redshift_subnets" {
  source = "../../../modules/subnet"

  name   = "${local.name}-redshift"
  vpc_id = module.vpc.id

  subnets_default = {
    route_table_id = module.private_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "172.16.41.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "172.16.42.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "172.16.43.0/24"
      availability_zone = "${local.region}c"
    }
  }

  redshift_subnet_groups = {
    redshift = {
      name                   = local.name
      description            = "Redshift subnet group for ${local.name}"
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]

      tags = {
        Name = local.name
      }
    }
  }

  tags = local.tags
}

module "intra_subnets" {
  source = "../../../modules/subnet"

  name   = "${local.name}-intra"
  vpc_id = module.vpc.id

  subnets_default = {
    route_table_id = module.intra_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "172.16.51.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "172.16.52.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "172.16.53.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}

################################################################################
# VPC Endpoints
################################################################################

module "vpc_endpoints" {
  source = "../../../modules/vpc-endpoints"

  vpc_id = module.vpc.id

  vpc_endpoint_defaults = {
    security_group_ids  = [aws_security_group.vpc_tls.id]
    subnet_ids          = module.private_subnets.ids
    private_dns_enabled = true
  }

  vpc_endpoints = {
    s3 = {
      private_dns_enabled = false
      tags                = { Name = "s3-vpc-endpoint" }
    },
    dynamodb = {
      service_type    = "Gateway"
      route_table_ids = [module.intra_route_table.id, module.private_route_table.id, module.public_route_table.id]
      policy          = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
      tags            = { Name = "dynamodb-vpc-endpoint" }
    },
    ssm           = {},
    ssmmessages   = {},
    lambda        = {},
    ecs           = {},
    ecs-telemetry = {},
    ec2           = {},
    ec2messages   = {},
    ecr_api = {
      service = "ecr.api"
      policy  = data.aws_iam_policy_document.generic_endpoint_policy.json
    },
    ecr_dkr = {
      service = "ecr.dkr"
      policy  = data.aws_iam_policy_document.generic_endpoint_policy.json
    },
    kms                        = {},
    codedeploy                 = {},
    codedeploy-commands-secure = {},
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

      values = [module.vpc.id]
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

      values = [module.vpc.id]
    }
  }
}

resource "aws_security_group" "vpc_tls" {
  name_prefix = "${local.name}-vpc_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.ipv4_cidr_block]
  }

  tags = local.tags
}
