################################################################################
# Firewall
################################################################################

resource "aws_networkfirewall_firewall" "this" {
  count = var.create ? 1 : 0

  delete_protection = var.delete_protection
  description       = var.description

  dynamic "encryption_configuration" {
    for_each = length(var.encryption_configuration) > 0 ? [var.encryption_configuration] : []

    content {
      key_id = try(encryption_configuration.value.key_id, null)
      type   = encryption_configuration.value.type
    }
  }

  firewall_policy_arn               = var.create_firewall_policy ? aws_networkfirewall_firewall_policy.this[0].arn : var.firewall_policy_arn
  firewall_policy_change_protection = var.firewall_policy_change_protection
  name                              = var.name
  subnet_change_protection          = var.subnet_change_protection

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping

    content {
      ip_address_type = try(subnet_mapping.value.ip_address_type, null)
      subnet_id       = subnet_mapping.value
    }
  }

  vpc_id = var.vpc_id

  tags = var.tags
}

################################################################################
# Firewall Policy
################################################################################

resource "aws_networkfirewall_firewall_policy" "this" {
  count = var.create && var.create_firewall_policy ? 1 : 0

  description = var.policy_description

  dynamic "encryption_configuration" {
    for_each = length(var.policy_encryption_configuration) > 0 ? [var.policy_encryption_configuration] : []

    content {
      key_id = try(encryption_configuration.value.key_id, null)
      type   = encryption_configuration.value.type
    }
  }

  firewall_policy {
    # Stateful
    stateful_default_actions = var.policy_stateful_default_actions

    dynamic "stateful_engine_options" {
      for_each = length(var.policy_stateful_engine_options) > 0 ? [var.policy_stateful_engine_options] : []

      content {
        rule_order              = try(stateful_rule_group_reference.value.rule_order, null)
        stream_exception_policy = try(stateful_rule_group_reference.value.stream_exception_policy, null)
      }
    }

    dynamic "stateful_rule_group_reference" {
      for_each = var.policy_stateful_rule_group_reference

      content {
        dynamic "override" {
          for_each = try([stateful_rule_group_reference.value.override], [])

          content {
            action = try(override.value.action, null)
          }
        }

        priority     = try(stateful_rule_group_reference.value.priority, null)
        resource_arn = try(stateful_rule_group_reference.value.resource_arn, aws_networkfirewall_rule_group.this[stateful_rule_group_reference.value.rule_group_key].arn, "REQUIRED")
      }
    }

    # Stateless
    dynamic "stateless_custom_action" {
      for_each = var.policy_stateless_custom_action

      content {
        action_name = stateless_custom_action.value.action_name

        dynamic "action_definition" {
          for_each = stateless_custom_action.value.action_definition

          content {
            dynamic "publish_metric_action" {
              for_each = action_definition.value.publish_metric_action

              content {
                dynamic "dimension" {
                  for_each = publish_metric_action.value.dimension

                  content {
                    value = dimension.value.value
                  }
                }
              }
            }
          }
        }
      }
    }

    stateless_default_actions          = var.policy_stateless_default_actions
    stateless_fragment_default_actions = var.policy_stateless_fragment_default_actions

    dynamic "stateless_rule_group_reference" {
      for_each = var.policy_stateless_rule_group_reference

      content {
        priority     = stateless_rule_group_reference.value.priority
        resource_arn = try(stateless_rule_group_reference.value.resource_arn, aws_networkfirewall_rule_group.this[stateless_rule_group_reference.value.rule_group_key].arn, "REQUIRED")
      }
    }
  }

  name = var.name

  tags = var.tags
}

################################################################################
# Firewall Rule Group
################################################################################

resource "aws_networkfirewall_rule_group" "this" {
  for_each = { for k, v in var.rule_groups : k => v if var.create && var.create_rule_groups }

  capacity    = each.value.capacity
  description = try(each.value.description, null)

  dynamic "encryption_configuration" {
    for_each = try([each.value.encryption_configuration], [])

    content {
      key_id = try(encryption_configuration.value.key_id, null)
      type   = encryption_configuration.value.type
    }
  }

  name = try(each.value.name, "${var.name}-${each.key}")

  dynamic "rule_group" {
    for_each = try([each.value.rule_group], [])

    content {

      dynamic "rule_variables" {
        for_each = try([rule_group.value.rule_variables], [])
        content {

          dynamic "ip_sets" {
            # One or more
            for_each = try(rule_variables.value.ip_sets, [])
            content {
              key = ip_sets.value.key
              dynamic "ip_set" {
                for_each = [ip_sets.value.ip_set]
                content {
                  definition = ip_set.value.definition
                }
              }
            }
          }

          dynamic "port_sets" {
            # One or more
            for_each = try(rule_variables.value.port_sets, [])
            content {
              key = port_sets.value.key
              dynamic "port_set" {
                for_each = [port_sets.value.port_set]
                content {
                  definition = port_set.value.definition
                }
              }
            }
          }
        }
      }

      dynamic "rules_source" {
        for_each = [rule_group.value.rules_source]
        content {
          rules_string = try(rules_source.value.rules_string, null)

          dynamic "rules_source_list" {
            for_each = try([rules_source.value.rules_source_list], [])
            content {
              generated_rules_type = rules_source_list.value.generated_rules_type
              target_types         = rules_source_list.value.target_types
              targets              = rules_source_list.value.targets
            }
          }

          dynamic "stateful_rule" {
            # One or more
            for_each = try(rules_source.value.stateful_rule, [])
            content {
              action = stateful_rule.value.action

              dynamic "header" {
                for_each = [stateful_rule.value.header]
                content {
                  destination      = header.value.destination
                  destination_port = header.value.destination_port
                  direction        = header.value.direction
                  protocol         = header.value.protocol
                  source           = header.value.source
                  source_port      = header.value.source_port
                }
              }

              dynamic "rule_option" {
                # One or more
                for_each = stateful_rule.value.rule_option
                content {
                  keyword  = rule_option.value.keyword
                  settings = try(rule_option.value.settings, null)
                }
              }
            }
          }

          dynamic "stateless_rules_and_custom_actions" {
            for_each = try([rules_source.value.stateless_rules_and_custom_actions], [])
            content {

              dynamic "custom_action" {
                # One or more
                for_each = try(stateless_rules_and_custom_actions.value.custom_action, [])
                content {
                  action_name = custom_action.value.action_name

                  dynamic "action_definition" {
                    for_each = [custom_action.value.action_definition]
                    content {
                      dynamic "publish_metric_action" {
                        for_each = [action_definition.value.publish_metric_action]
                        content {
                          dynamic "dimension" {
                            # One or more
                            for_each = publish_metric_action.value.dimension
                            content {
                              value = dimension.value.value
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              dynamic "stateless_rule" {
                # One or more
                for_each = stateless_rules_and_custom_actions.value.stateless_rule
                content {
                  priority = stateless_rule.value.priority

                  dynamic "rule_definition" {
                    for_each = [stateless_rule.value.rule_definition]
                    content {
                      actions = rule_definition.value.actions

                      dynamic "match_attributes" {
                        for_each = [rule_definition.value.match_attributes]
                        content {

                          protocols = try(match_attributes.value.protocols, [])

                          dynamic "destination" {
                            # One or more
                            for_each = try(match_attributes.value.destination, [])
                            content {
                              address_definition = destination.value.address_definition
                            }
                          }

                          dynamic "destination_port" {
                            # One or more
                            for_each = try(match_attributes.value.destination_port, [])
                            content {
                              from_port = destination_port.value.from_port
                              to_port   = try(destination_port.value.to_port, null)
                            }
                          }

                          dynamic "source" {
                            # One or more
                            for_each = try(match_attributes.value.source, [])
                            content {
                              address_definition = source.value.address_definition
                            }
                          }

                          dynamic "source_port" {
                            # One or more
                            for_each = try(match_attributes.value.source_port, [])
                            content {
                              from_port = source_port.value.from_port
                              to_port   = try(source_port.value.to_port, null)
                            }
                          }

                          dynamic "tcp_flag" {
                            # One or more
                            for_each = try(match_attributes.value.tcp_flag, [])
                            content {
                              flags = tcp_flag.value.flags
                              masks = try(tcp_flag.value.masks, [])
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "stateful_rule_options" {
        for_each = try([rule_group.value.stateful_rule_options], [])
        content {
          rule_order = stateful_rule_options.value.rule_order
        }
      }
    }
  }

  rules = try(each.value.rules, null)
  type  = each.value.type

  tags = merge(var.tags, try(each.value.tags, {}))
}

################################################################################
# Firewall Resource Policies
################################################################################

# Firewall Policy
data "aws_iam_policy_document" "firewall_policy" {
  count = var.create && var.create_firewall_policy && var.create_firewall_policy_resource_policy ? 1 : 0

  statement {
    sid       = "NetworkFirewallResourcePolicy"
    actions   = var.firewall_policy_resource_policy_actions
    resources = [aws_networkfirewall_firewall_policy.this[0].arn]

    principals {
      type        = "AWS"
      identifiers = var.firewall_policy_resource_policy_principals
    }
  }
}

resource "aws_networkfirewall_resource_policy" "firewall_policy" {
  count = var.create && var.create_firewall_policy && var.attach_firewall_policy_resource_policy ? 1 : 0

  resource_arn = aws_networkfirewall_firewall_policy.this[0].arn
  policy       = var.create_firewall_policy_resource_policy ? data.aws_iam_policy_document.firewall_policy[0].json : var.firewall_policy_resource_policy
}

# Rule Group(s)
data "aws_iam_policy_document" "rule_group" {
  for_each = { for k, v in var.rule_groups : k => v if var.create && try(v.create_resource_policy, false) }

  statement {
    sid = "RuleGroupResourcePolicy"
    actions = try(each.value.resource_policy_actions, [
      "network-firewall:ListRuleGroups",
      "network-firewall:CreateFirewallPolicy",
      "network-firewall:UpdateFirewallPolicy"
    ])
    resources = [aws_networkfirewall_rule_group.this[each.key].arn]

    principals {
      type        = "AWS"
      identifiers = try(each.value.resource_policy_principals, [])
    }
  }
}

resource "aws_networkfirewall_resource_policy" "rule_group" {
  for_each = { for k, v in var.rule_groups : k => v if var.create && try(v.attach_resource_policy, false) }

  resource_arn = aws_networkfirewall_rule_group.this[each.key].arn
  policy       = try(each.value.create_resource_policy, false) ? data.aws_iam_policy_document.rule_group[each.key].json : each.value.resource_policy
}

################################################################################
# Firewall Logging Configuration
################################################################################

resource "aws_networkfirewall_logging_configuration" "this" {
  count = var.create && var.create_logging_configuration ? 1 : 0

  firewall_arn = aws_networkfirewall_firewall.this[0].arn

  logging_configuration {
    # At least one config, at most, only two blocks can be specified; one for `FLOW` logs and one for `ALERT` logs.
    dynamic "log_destination_config" {
      for_each = var.logging_configuration_destination_config
      content {
        log_destination      = log_destination_config.value.log_destination
        log_destination_type = log_destination_config.value.log_destination_type
        log_type             = log_destination_config.value.log_type
      }
    }
  }
}

################################################################################
# RAM Resource Association
################################################################################

resource "aws_ram_resource_association" "firewall_policy" {
  for_each = { for k, v in var.firewall_policy_ram_resource_associations : k => v if var.create && var.create_firewall_policy }

  resource_arn       = aws_networkfirewall_firewall_policy.this[0].arn
  resource_share_arn = each.value.resource_share_arn
}

resource "aws_ram_resource_association" "rule_group" {
  for_each = { for k, v in var.rule_groups_ram_resource_associations : k => v if var.create && var.create_rule_groups }

  resource_arn       = aws_networkfirewall_rule_group.this[each.value.rule_group_key].arn
  resource_share_arn = each.value.resource_share_arn
}
