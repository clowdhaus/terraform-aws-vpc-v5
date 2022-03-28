provider "aws" {
  region = local.region
}

locals {
  name       = "vpc-ex-${replace(basename(path.cwd), "_", "-")}"
  region     = "eu-west-1"
  account_id = data.aws_caller_identity.current.account_id

  subnets = {
    "${local.region}a" = {
      public_ipv4_cidr_block = "10.0.0.0/24"
    }
    "${local.region}b" = {
      public_ipv4_cidr_block = "10.0.0.0/24"
    }
    "${local.region}c" = {
      public_ipv4_cidr_block = "10.0.0.0/24"
    }
  }

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc-v4"
  }
}

data "aws_caller_identity" "current" {}

################################################################################
# VPC
################################################################################

module "vpc" {
  source = "../../"

  name                 = local.name
  ipv4_cidr_block      = "10.0.0.0/17"
  enable_dns_hostnames = true
  vpc_tags             = { vpc_tags = true }

  ipv4_cidr_block_associations = {
    # This matches the provider API to avoid re-creating the association
    "10.0.128.0/17" = {
      ipv4_cidr_block = "10.0.128.0/17"
      timeouts = {
        create = "12m"
        delete = "12m"
      }
    }
  }

  # DNS Firewall
  enable_dns_firewall = true
  dns_firewall_rule_group_associations = {
    one = {
      name                   = local.name
      firewall_rule_group_id = module.dns_firewall_rule_group.id
      priority               = 101
      # Disable for test/example
      mutation_protection = "DISABLED"
    }
  }

  # DNS Query Logging
  enable_dns_query_logging     = true
  dns_query_log_destintion_arn = aws_s3_bucket.dns_query_logs.arn

  # DHCP
  create_dhcp_options              = true
  dhcp_options_domain_name         = "${local.region}.compute.internal"
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]
  dhcp_options_ntp_servers         = ["169.254.169.123"]
  dhcp_options_netbios_node_type   = 2
  dhcp_options_tags                = { dhcp_options_tags = true }

  tags = local.tags
}

################################################################################
# VPC Flow Log
################################################################################

module "vpc_flow_log" {
  source = "../../modules/flow-log"

  vpc_id = module.vpc.id

  create_cloudwatch_log_group            = true
  cloudwatch_log_group_name              = "/aws/flow-log/vpc-${module.vpc.id}"
  cloudwatch_log_group_retention_in_days = 7
  create_cloudwatch_iam_role             = true

  tags = local.tags
}

################################################################################
# Subnets
################################################################################

module "public_subnet" {
  source = "../../modules/subnet"

  for_each = local.subnets

  name   = "${local.name}-public-${each.key}"
  vpc_id = module.vpc.id

  availability_zone       = each.key
  map_public_ip_on_launch = true
  ipv4_cidr_block         = each.value.public_ipv4_cidr_block

  cidr_reservations = each.key == "${local.region}a" ? {
    one = {
      subnet_key       = "${local.region}a"
      description      = "Example EC2 subnet CIDR reservation"
      cidr_block       = "10.0.0.0/28"
      reservation_type = "prefix"
    }
    two = {
      subnet_key       = "${local.region}b"
      description      = "Example EC2 subnet CIDR reservation"
      cidr_block       = "10.0.0.16/28"
      reservation_type = "prefix"
    }
  } : {}

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
  subnet_ids = [for subnet in module.public_subnet : subnet.id]

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
# DNS Firewall Module
################################################################################

module "dns_firewall_rule_group" {
  source = "../../modules/dns-firewall-rule-group"

  name = local.name

  rules = {
    block = {
      name           = "blockit"
      priority       = 110
      action         = "BLOCK"
      block_response = "NODATA"
      domains        = ["google.com."]

      tags = { rule = true }
    }
    block_override = {
      priority                = 120
      action                  = "BLOCK"
      block_response          = "OVERRIDE"
      block_override_dns_type = "CNAME"
      block_override_domain   = "example.com."
      block_override_ttl      = 1
      domains                 = ["microsoft.com."]
    }
    # # unfortunately there is not a data source yet to pull managed domain lists
    # # so keeping this commented out but available for reference
    # block_managed_domain_list = {
    #   priority       = 135
    #   action         = "BLOCK"
    #   block_response = "NODATA"
    #   domain_list_id = "xxxx"
    # }
    allow = {
      priority = 130
      action   = "ALLOW"
      domains  = ["amazon.com.", "amazonaws.com."]
    }
  }

  tags = local.tags
}

################################################################################
# Network Firewall Module
################################################################################

module "network_firewall" {
  source = "../../modules/network-firewall"

  name        = local.name
  description = "Example network firewall"

  vpc_id         = module.vpc.id
  subnet_mapping = [for subnet in module.public_subnet : subnet.id]

  # Disable for testing
  delete_protection        = false
  subnet_change_protection = false

  # Policy
  policy_description = "Example network firewall policy"
  policy_stateful_rule_group_reference = [
    { rule_group_key = "stateful_ex1" },
    { rule_group_key = "stateful_ex2" },
    { rule_group_key = "stateful_ex3" },
    { rule_group_key = "stateful_ex4" },
  ]

  policy_stateless_default_actions          = ["aws:pass"]
  policy_stateless_fragment_default_actions = ["aws:drop"]
  policy_stateless_rule_group_reference = [
    {
      priority       = 1
      rule_group_key = "stateless_ex1"
    },
  ]

  # Rule Group(s)
  rule_groups = {

    stateful_ex1 = {
      name        = "${local.name}-stateful-ex1"
      description = "Stateful Inspection for denying access to a domain"
      type        = "STATEFUL"
      capacity    = 100

      rule_group = {
        rules_source = {
          rules_source_list = {
            generated_rules_type = "DENYLIST"
            target_types         = ["HTTP_HOST"]
            targets              = ["test.example.com"]
          }
        }
      }

      # Resource Policy - Rule Group
      create_resource_policy     = true
      attach_resource_policy     = true
      resource_policy_principals = [data.aws_caller_identity.current.arn]
    }

    stateful_ex2 = {
      name        = "${local.name}-stateful-ex2"
      description = "Stateful Inspection for permitting packets from a source IP address"
      type        = "STATEFUL"
      capacity    = 50

      rule_group = {
        rules_source = {
          stateful_rule = [{
            action = "PASS"
            header = {
              destination      = "ANY"
              destination_port = "ANY"
              protocol         = "HTTP"
              direction        = "ANY"
              source_port      = "ANY"
              source           = "1.2.3.4"
            }
            rule_option = [{
              keyword = "sid:1"
            }]
          }]
        }
      }
    }

    stateful_ex3 = {
      name        = "${local.name}-stateful-ex3"
      description = "Stateful Inspection for blocking packets from going to an intended destination"
      type        = "STATEFUL"
      capacity    = 100

      rule_group = {
        rules_source = {
          stateful_rule = [{
            action = "DROP"
            header = {
              destination      = "124.1.1.24/32"
              destination_port = 53
              direction        = "ANY"
              protocol         = "TCP"
              source           = "1.2.3.4/32"
              source_port      = 53
            }
            rule_option = [{
              keyword = "sid:1"
            }]
          }]
        }
      }
    }

    stateful_ex4 = {
      name        = "${local.name}-stateful-ex4"
      description = "Stateful Inspection from rule group specifications using rule variables and Suricata format rules"
      type        = "STATEFUL"
      capacity    = 100

      rule_group = {
        rule_variables = {
          ip_sets = [{
            key = "WEBSERVERS_HOSTS"
            ip_set = {
              definition = ["10.1.0.0/16", "10.1.1.0/24", "192.168.0.0/16"]
            }
            }, {
            key = "EXTERNAL_HOST"
            ip_set = {
              definition = ["1.2.3.4/32"]
            }
          }]
          port_sets = [{
            key = "HTTP_PORTS"
            port_set = {
              definition = ["443", "80"]
            }
          }]
        }
        rules_source = {
          rules_string = <<-EOT
          alert icmp any any -> any any (msg: "Allowing ICMP packets"; sid:1; rev:1;)
          pass icmp any any -> any any (msg: "Allowing ICMP packets"; sid:2; rev:1;)
          EOT
        }
      }
    }

    stateless_ex1 = {
      name        = "${local.name}-stateless-ex1"
      description = "Stateless Inspection with a Custom Action"
      type        = "STATELESS"
      capacity    = 100

      rule_group = {
        rules_source = {
          stateless_rules_and_custom_actions = {
            custom_action = [{
              action_definition = {
                publish_metric_action = {
                  dimension = [{
                    value = "2"
                  }]
                }
              }
              action_name = "ExampleMetricsAction"
            }]
            stateless_rule = [{
              priority = 1
              rule_definition = {
                actions = ["aws:pass", "ExampleMetricsAction"]
                match_attributes = {
                  source = [{
                    address_definition = "1.2.3.4/32"
                  }]
                  source_port = [{
                    from_port = 443
                    to_port   = 443
                  }]
                  destination = [{
                    address_definition = "124.1.1.5/32"
                  }]
                  destination_port = [{
                    from_port = 443
                    to_port   = 443
                  }]
                  protocols = [6]
                  tcp_flag = [{
                    flags = ["SYN"]
                    masks = ["SYN", "ACK"]
                  }]
                }
              }
            }]
          }
        }
      }

      # Resource Policy - Rule Group
      create_resource_policy     = true
      attach_resource_policy     = true
      resource_policy_principals = [data.aws_caller_identity.current.arn]
    }
  }

  # Resource Policy - Firewall Policy
  create_firewall_policy_resource_policy     = true
  attach_firewall_policy_resource_policy     = true
  firewall_policy_resource_policy_principals = [data.aws_caller_identity.current.arn]

  # Logging configuration
  create_logging_configuration = true
  logging_configuration_destination_config = [
    {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.logs.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    },
    {
      log_destination = {
        bucketName = aws_s3_bucket.network_firewall_logs.id
        prefix     = local.name
      }
      log_destination_type = "S3"
      log_type             = "FLOW"
    }
  ]


  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

resource "aws_cloudwatch_log_group" "logs" {
  name              = "${local.name}-logs"
  retention_in_days = 7

  tags = local.tags
}

resource "aws_s3_bucket" "network_firewall_logs" {
  bucket        = "${local.name}-network-firewall-logs-${local.account_id}"
  force_destroy = true

  tags = local.tags
}

# Logging configuration automatically adds this policy if not present
resource "aws_s3_bucket_policy" "network_firewall_logs" {
  bucket = aws_s3_bucket.network_firewall_logs.id
  policy = jsonencode({
    Version = "2012-10-17"
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
        Resource = "${aws_s3_bucket.network_firewall_logs.arn}/${local.name}/AWSLogs/${local.account_id}/*"
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
        Resource = aws_s3_bucket.network_firewall_logs.arn
        Sid      = "AWSLogDeliveryAclCheck"
      },
    ]
  })
}

# DNS Query Logging
resource "aws_s3_bucket" "dns_query_logs" {
  bucket        = "${local.name}-dns-query-logs-${local.account_id}"
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
