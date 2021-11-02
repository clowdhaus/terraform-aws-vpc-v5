variable "create" {
  description = "Controls if network ACL resources should be created"
  type        = bool
  default     = true
}

variable "name" {
  description = "Default name to be used as a prefix for the resources created (if a custom name is not provided)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Network ACL
################################################################################

variable "vpc_id" {
  description = "The ID of the associated VPC"
  type        = string
  default     = ""
}

variable "network_acls" {
  description = "Map of network ACLs"
  type        = any
  default     = {}
}

variable "network_acl_rules" {
  description = "Map of network ACL rules"
  type        = map(any)
  default     = {}
}
