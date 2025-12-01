provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}

locals {
  name       = "vpc-ex-${basename(path.cwd)}"
  region     = "eu-west-1"
  account_id = data.aws_caller_identity.current.account_id

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc-v7"
  }
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source = "../../"

  name                 = local.name
  ipv4_cidr_block      = "10.0.0.0/17"
  enable_dns_hostnames = true
  vpc_tags             = { vpc_tags = true }

  # ipv4_cidr_block_associations = {
  #   # This matches the provider API to avoid re-creating the association
  #   "10.0.128.0/17" = {
  #     ipv4_cidr_block = "10.0.128.0/17"
  #     timeouts = {
  #       create = "12m"
  #       delete = "12m"
  #     }
  #   }
  # }

  # # DNS Firewall
  # enable_dns_firewall = true
  # dns_firewall_rule_group_associations = {
  #   one = {
  #     name                   = local.name
  #     firewall_rule_group_id = module.dns_firewall_rule_group.id
  #     priority               = 101
  #     # Disable for test/example
  #     mutation_protection = "DISABLED"
  #   }
  # }

  # DNS Query Logging
  enable_dns_query_logging      = true
  dns_query_log_destination_arn = aws_s3_bucket.dns_query_logs.arn

  # DHCP
  dhcp_options = {
    domain_name         = "${local.region}.compute.internal"
    domain_name_servers = ["AmazonProvidedDNS"]
    ntp_servers         = ["169.254.169.123"]
    netbios_node_type   = 2
  }

  tags = local.tags
}

################################################################################
# Subnets
################################################################################

module "public_subnets" {
  source = "../../modules/subnet"

  for_each = {
    "${local.region}a" = {
      public_ipv4_cidr_block = "10.0.0.0/24"
    }
    "${local.region}b" = {
      public_ipv4_cidr_block = "10.0.0.1/24"
    }
    "${local.region}c" = {
      public_ipv4_cidr_block = "10.0.0.2/24"
    }
  }

  name   = "${local.name}-public-${each.key}"
  vpc_id = module.vpc.id

  availability_zone = each.key
  ipv4_cidr_block   = each.value.public_ipv4_cidr_block

  routes = {
    igw = {
      destination_ipv4_cidr_block = "0.0.0.0/0"
      gateway_id                  = module.vpc.internet_gateway_id
    }
  }

  tags = local.tags
}

################################################################################
# Network ACL
################################################################################

module "public_network_acl" {
  source = "../../modules/network-acl"

  vpc_id     = module.vpc.id
  subnet_ids = [for subnet in module.public_subnets : subnet.id]

  ingress_rules = {
    100 = {
      protocol        = "-1"
      rule_action     = "Allow"
      ipv4_cidr_block = module.vpc.ipv4_cidr_block
      from_port       = 0
      to_port         = 0
    }
  }

  egress_rules = {
    100 = {
      protocol        = "-1"
      rule_action     = "Allow"
      ipv4_cidr_block = "0.0.0.0/0"
      from_port       = 0
      to_port         = 0
    }
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

# DNS Query Logging
resource "aws_s3_bucket" "dns_query_logs" {
  bucket_prefix = "${local.name}-dns-query-logs-"
  force_destroy = true

  tags = local.tags
}

# Query log configuration automatically adds this policy if not present
resource "aws_s3_bucket_policy" "dns_query_logs" {
  bucket = aws_s3_bucket.dns_query_logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AWSLogDeliveryWrite20150319"
    Statement = [
      {
        Action = "s3:PutObject"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:${local.region}:${local.account_id}:*"
          }
          StringEquals = {
            "aws:SourceAccount" = local.account_id
            "s3:x-amz-acl"      = "bucket-owner-full-control"
          }
        }
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Resource = "${aws_s3_bucket.dns_query_logs.arn}/AWSLogs/${local.account_id}/*"
        Sid      = "AWSLogDeliveryWrite"
      },
      {
        Action = "s3:GetBucketAcl"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:${local.region}:${local.account_id}:*"
          }
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
        }
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Resource = aws_s3_bucket.dns_query_logs.arn
        Sid      = "AWSLogDeliveryAclCheck"
      },
    ]
  })
}
