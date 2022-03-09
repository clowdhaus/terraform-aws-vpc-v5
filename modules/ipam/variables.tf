variable "create" {
  description = "Controls if resources should be created; affects all resources"
  type        = bool
  default     = true
}

# variable "name" {
#   description = "Name of used across the resources created"
#   type        = string
#   default     = ""
# }

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# IPAM
################################################################################

variable "description" {
  description = "Description for the IPAM"
  type        = string
  default     = null
}

variable "operating_regions" {
  description = "Determines which locales can be chosen when you create pools. Locale is the Region where you want to make an IPAM pool available for allocations. You can only create pools with locales that match the operating Regions of the IPAM. You can only create VPCs from a pool whose locale matches the VPC's Region"
  type        = list(string)
  default     = []
}

################################################################################
# IPAM Scope
################################################################################

variable "scopes" {
  description = "A map of scope definitions to be created"
  type        = any
  default     = {}
}

################################################################################
# IPAM Pool
################################################################################

variable "pools" {
  description = "A map of pool definitions to be created"
  type        = any
  default     = {}
}
