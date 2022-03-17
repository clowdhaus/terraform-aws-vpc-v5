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
  ipv4_cidr_block = "10.10.0.0/16" # 10.0.0.0/8 is reserved for EC2-Classic

  # Not in v3.x
  enable_dnssec_config = false

  manage_default_network_acl = true
  default_network_acl_tags   = { Name = "${local.name}-default" }

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
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  # # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  # enable_flow_log                      = true
  # create_flow_log_cloudwatch_log_group = true
  # create_flow_log_cloudwatch_iam_role  = true
  # flow_log_max_aggregation_interval    = 60

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
    igw_ipv6 = {
      destination_ipv6_cidr_block = "::/0"
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
    eigw_ipv6 = {
      destination_ipv6_cidr_block = "::/0"
      egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
    }
  }

  tags = local.tags
}

module "database_route_table" {
  source = "../../../modules/route-table"

  name   = "${local.name}-database"
  vpc_id = module.vpc.id

  routes = {
    igw_ipv4 = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = module.vpc.internet_gateway_id
    }
    eigw_ipv6 = {
      destination_ipv6_cidr_block = "::/0"
      egress_only_gateway_id      = module.vpc.egress_only_internet_gateway_id
    }
  }

  tags = local.tags
}

module "elasticache_route_table" {
  source = "../../../modules/route-table"

  name   = "${local.name}-elasticache"
  vpc_id = module.vpc.id

  tags = local.tags
}

module "redshift_route_table" {
  source = "../../../modules/route-table"

  name   = "${local.name}-redshift"
  vpc_id = module.vpc.id

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
  source = "../../../modules/subnets"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

  subnets_default = {
    map_public_ip_on_launch = true
    route_table_id          = module.public_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.10.11.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.10.12.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.10.13.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}

module "private_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

  subnets_default = {
    route_table_id = module.private_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.0.1.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.2.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.0.3.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}

module "database_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-database"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

  subnets_default = {
    route_table_id = module.database_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.0.21.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.22.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.0.23.0/24"
      availability_zone = "${local.region}c"
    }
  }

  rds_subnet_groups = {
    database = {
      name                   = local.name
      description            = "Database subnet group for ${local.name}"
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]

      tags = {
        Name = local.name
      }
    }
  }

  tags = local.tags
}

module "elasticache_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-elasticache"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

  subnets_default = {
    route_table_id = module.elasticache_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.0.31.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.32.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.0.33.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}

module "redshift_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-redshift"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

  subnets_default = {
    route_table_id = module.redshift_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.0.41.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.42.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.0.43.0/24"
      availability_zone = "${local.region}c"
    }
  }

  tags = local.tags
}

module "intra_subnets" {
  source = "../../../modules/subnets"

  name   = "${local.name}-intra"
  vpc_id = module.vpc.id

  # Backwards compat
  create_network_acl = false

  subnets_default = {
    route_table_id = module.intra_route_table.id
  }

  subnets = {
    "${local.region}a" = {
      ipv4_cidr_block   = "10.0.51.0/24"
      availability_zone = "${local.region}a"
    }
    "${local.region}b" = {
      ipv4_cidr_block   = "10.0.52.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      ipv4_cidr_block   = "10.0.53.0/24"
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

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [data.aws_security_group.default.id]

  vpc_endpoints = {
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
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [aws_security_group.vpc_tls.id]
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    lambda = {
      service             = "lambda"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ecs = {
      service             = "ecs"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ecs_telemetry = {
      service             = "ecs-telemetry"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [aws_security_group.vpc_tls.id]
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
    },
    kms = {
      service             = "kms"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [aws_security_group.vpc_tls.id]
    },
    codedeploy = {
      service             = "codedeploy"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    codedeploy_commands_secure = {
      service             = "codedeploy-commands-secure"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
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

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

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
