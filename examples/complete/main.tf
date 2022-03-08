provider "aws" {
  region = local.region
}

locals {
  name   = "vpc-ex-${replace(basename(path.cwd), "_", "-")}"
  region = "eu-west-1"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc-v4"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../"

  name                 = local.name
  cidr_block           = "10.99.0.0/16"
  enable_dns_hostnames = true
  vpc_tags             = { vpc_tags = true }

  ipv4_cidr_block_associations = {
    # This matches the provider API to avoid re-creating the association
    "10.98.0.0/16" = {
      cidr_block = "10.98.0.0/16"
      timeouts = {
        create = "12m"
        delete = "12m"
      }
    }
  }

  # Flow Log
  create_flow_log                                 = true
  create_flow_log_cloudwatch_iam_role             = true
  create_flow_log_cloudwatch_log_group            = true
  flow_log_cloudwatch_log_group_retention_in_days = 7
  flow_log_tags                                   = { flow_log_tags = true }

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
# Subnets Module
################################################################################

module "public_subnets" {
  source = "../../modules/subnets"

  # Because IGW exists in `module.vpc`, we implictly depend on that first (for NAT Gateway/EIP requirements)

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  subnets = {
    "${local.region}a" = {
      cidr_block         = "10.98.1.0/24"
      availability_zone  = "${local.region}a"
      create_nat_gateway = true
      ec2_subnet_cidr_reservations = {
        one = {
          description      = "Example EC2 subnet CIDR reservation"
          cidr_block       = "10.98.1.0/28"
          reservation_type = "prefix"
        }
        two = {
          description      = "Example EC2 subnet CIDR reservation"
          cidr_block       = "10.98.1.16/28"
          reservation_type = "prefix"
        }
      }
    }
    "${local.region}b" = {
      cidr_block        = "10.98.2.0/24"
      availability_zone = "${local.region}b"
    }
    # public_3 = {
    #   cidr_block = "10.98.3.0/24"
    #   availability_zone = "${local.region}c"
    # }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b"]
      routes = {
        igw = {
          destination_cidr_block = "0.0.0.0/0"
          gateway_id             = module.vpc.internet_gateway_id
        }
      }
    }
  }

  ingress_network_acl_rules = {
    100 = {
      protocol    = "-1"
      rule_action = "Allow"
      cidr_block  = module.vpc.cidr_block
      from_port   = 0
      to_port     = 0
    }
  }

  egress_network_acl_rules = {
    100 = {
      protocol    = "-1"
      rule_action = "Allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
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
  subnet_mapping = module.public_subnets.ids

  # Policy
  policy_stateful_rule_group_reference = [
    { rule_group_key = "stateful_ex1" },
    { rule_group_key = "stateful_ex2" },
    { rule_group_key = "stateful_ex3" },
    { rule_group_key = "stateful_ex4" },
  ]
  policy_stateless_rule_group_reference = [
    { rule_group_key = "stateless_ex1" },
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
              definition = ["10.0.0.0/16", "10.0.1.0/24", "192.168.0.0/16"]
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
    }
  }

  # # Resource Policy
  # resource_policies = {
  #   firewall_policy = {
  #     policy =
  #   }
  #   stateful_ex1_rule_group = {
  #     rule_group_key = "stateful_ex1"
  #     policy =
  #   }
  # }

  tags = local.tags
}
