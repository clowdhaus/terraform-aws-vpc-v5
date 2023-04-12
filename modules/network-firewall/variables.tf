variable "create" {
  description = "Controls if Network Firewall resources should be created"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Firewall
################################################################################

variable "delete_protection" {
  description = "A boolean flag indicating whether it is possible to delete the firewall. Defaults to `true`"
  type        = bool
  default     = true
}

variable "description" {
  description = "Description of the Network Firewall"
  type        = string
  default     = ""
}

variable "encryption_configuration" {
  description = "KMS encryption configuration settings"
  type        = any
  default     = {}
}

variable "firewall_policy_arn" {
  description = "The ARN of the Firewall Policy to use; required when `create_firewall_policy` is `false`"
  type        = string
  default     = ""
}

variable "firewall_policy_change_protection" {
  description = "A boolean flag indicating whether it is possible to change the associated firewall policy. Defaults to `false`"
  type        = bool
  default     = null
}

variable "vpc_id" {
  description = "The unique identifier of the VPC where AWS Network Firewall should create the firewall"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name of the Network Firewall"
  type        = string
  default     = ""
}

variable "subnet_change_protection" {
  description = "A boolean flag indicating whether it is possible to change the associated subnet(s). Defaults to `true`"
  type        = bool
  default     = true
}

variable "subnet_mapping" {
  description = "Set of configuration blocks describing the public subnets. Each subnet must belong to a different Availability Zone in the VPC. AWS Network Firewall creates a firewall endpoint in each subnet"
  type        = list(string)
  default     = []
}

################################################################################
# Firewall Policy
################################################################################

variable "create_firewall_policy" {
  description = "Controls if a Firewall Policy should be created"
  type        = bool
  default     = true
}

variable "policy_description" {
  description = "A friendly description of the firewall policy"
  type        = string
  default     = null
}

variable "policy_encryption_configuration" {
  description = "KMS encryption configuration settings"
  type        = any
  default     = {}
}

variable "policy_stateful_default_actions" {
  description = "Set of actions to take on a packet if it does not match any stateful rules in the policy. This can only be specified if the policy has a `stateful_engine_options` block with a rule_order value of `STRICT_ORDER`. You can specify one of either or neither values of `aws:drop_strict` or `aws:drop_established`, as well as any combination of `aws:alert_strict` and `aws:alert_established`"
  type        = list(string)
  default     = []
}

variable "policy_stateful_engine_options" {
  description = "A configuration block that defines options on how the policy handles stateful rules. See [Stateful Engine Options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateful-engine-options) for details"
  type        = any
  default     = {}
}

variable "policy_stateful_rule_group_reference" {
  description = "Set of configuration blocks containing references to the stateful rule groups that are used in the policy. See [Stateful Rule Group Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateful-rule-group-reference) for details"
  type        = any
  default     = {}
}

variable "policy_stateless_custom_action" {
  description = "Set of configuration blocks describing the custom action definitions that are available for use in the firewall policy's `stateless_default_actions`"
  type        = any
  default     = {}
}

variable "policy_stateless_default_actions" {
  description = "Set of actions to take on a packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sfe`"
  type        = list(string)
  default     = ["aws:pass"]
}

variable "policy_stateless_fragment_default_actions" {
  description = "Set of actions to take on a fragmented packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sfe`"
  type        = list(string)
  default     = ["aws:pass"]
}

variable "policy_stateless_rule_group_reference" {
  description = "Set of configuration blocks containing references to the stateless rule groups that are used in the policy. See [Stateless Rule Group Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateless-rule-group-reference) for details"
  type        = any
  default     = {}
}

variable "firewall_policy_ram_resource_associations" {
  description = "A map of RAM resource associations for the created firewall policy"
  type        = map(string)
  default     = {}
}

################################################################################
# Firewall Rule Group
################################################################################

variable "create_rule_groups" {
  description = "Controls if Firewall Rule Groups should be created"
  type        = bool
  default     = true
}

variable "rule_groups" {
  description = "A map of Firewall Rule Group definitions to be created"
  type        = any
  default     = {}
}

variable "rule_groups_ram_resource_associations" {
  description = "A map of RAM resource associations for the created Firewall Rule Groups"
  type        = map(string)
  default     = {}
}

################################################################################
# Firewall Resource Policies
################################################################################

# Firewall Policy
variable "create_firewall_policy_resource_policy" {
  description = "Controls if a Firewall Policy Resource Policy should be created"
  type        = bool
  default     = false
}

variable "firewall_policy_resource_policy_actions" {
  description = "A list of IAM actions allowed in the Firewall Policy Resource Policy"
  type        = list(string)
  default = [
    "network-firewall:ListFirewallPolicies",
    "network-firewall:CreateFirewall",
    "network-firewall:UpdateFirewall",
    "network-firewall:AssociateFirewallPolicy",
  ]
}

variable "firewall_policy_resource_policy_principals" {
  description = "A list of IAM principals allowed in the Firewall Policy Resource Policy"
  type        = list(string)
  default     = []
}

variable "attach_firewall_policy_resource_policy" {
  description = "Controls if a Resource Policy should be attached to the Firewall Policy"
  type        = bool
  default     = false
}

variable "firewall_policy_resource_policy" {
  description = "The policy JSON to use for the Firewall Policy Resource Policy; required when `create_firewall_policy_resource_policy` is `false`"
  type        = string
  default     = ""
}

# Note: Rule group policies are captured under `rule_groups`

################################################################################
# Firewall Logging Configuration
################################################################################

variable "create_logging_configuration" {
  description = "Controls if a Logging Configuration should be created"
  type        = bool
  default     = false
}

variable "logging_configuration_destination_config" {
  description = "A list of min 1, max 2 configuration blocks describing the destination for the logging configuration"
  type        = any
  default     = []
}
