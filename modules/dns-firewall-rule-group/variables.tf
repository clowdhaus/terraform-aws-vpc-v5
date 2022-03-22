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
# RAM Resource Association
################################################################################

variable "ram_resource_associations" {
  description = "A map of RAM resource associations for the created rule group"
  type        = map(string)
  default     = {}
}

################################################################################
# Firewall Rules
################################################################################

variable "rules" {
  description = "A map of rule definitions to create"
  type        = any
  default     = {}
}
