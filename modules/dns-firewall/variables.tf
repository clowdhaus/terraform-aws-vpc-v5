variable "create" {
  description = "Controls if resources should be created; affects all resources"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of used across the resources created"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Firewall Config
################################################################################

variable "vpc_id" {
  description = "The ID of the VPC that the configuration is for"
  type        = string
  default     = ""
}

variable "firewall_fail_open" {
  description = "Determines how Route 53 Resolver handles queries during failures. Valid values: `ENABLED`, `DISABLED`. Defaults is `ENABLED`"
  type        = string
  default     = "ENABLED"
}

################################################################################
# Firewall Rules
################################################################################

variable "rules" {
  description = "A map of rule definitions to create"
  type        = any
  default     = {}
}

################################################################################
# Firewall Rule Group Association
################################################################################

variable "mutation_protection" {
  description = "If enabled, this setting disallows modification or removal of the association, to help prevent against accidentally altering DNS firewall protections. Valid values: `ENABLED`, `DISABLED`"
  type        = string
  default     = "ENABLED"
}

variable "priority" {
  description = "The setting that determines the processing order of the rule group among the rule groups that you associate with the specified VPC. DNS Firewall filters VPC traffic starting from the rule group with the lowest numeric priority setting. Must between `100` and `9900`"
  type        = number
  default     = 101
}
