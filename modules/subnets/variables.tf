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

variable "vpc_id" {
  description = "The ID of the VPC to create the resources in"
  type        = string
  default     = ""
}

################################################################################
# Subnet
################################################################################

variable "subnets" {
  description = "Map of subnet definitions"
  type        = map(any)
  default     = {}
}

variable "subnet_timeouts" {
  description = "Create and delete timeout configurations for subnets"
  type        = map(string)
  default     = {}
}

################################################################################
# Route Table
################################################################################

variable "route_tables" {
  description = "Map of route table definitions"
  type        = map(any)
  default     = {}
}

variable "route_table_timeouts" {
  description = "Create, update, and delete timeout configurations for route tables"
  type        = map(string)
  default     = {}
}

variable "routes" {
  description = "Map of route definitions"
  type        = map(any)
  default     = {}
}

################################################################################
# Network ACL
################################################################################

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
