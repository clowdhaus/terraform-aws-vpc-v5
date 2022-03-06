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
  type        = any
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
  description = "Create, update, and delete timeout configurations for route table"
  type        = map(string)
  default     = {}
}

variable "route_timeouts" {
  description = "Create, update, and delete timeout configurations for route table routes"
  type        = map(string)
  default     = {}
}

################################################################################
# Network ACL
################################################################################

variable "create_network_acl" {
  description = "Controls creation of Network ACL resources"
  type        = bool
  default     = true
}

variable "network_acl_rules" {
  description = "Network ACL rules to be added to the Network ACL"
  type        = map(any)
  default     = {}
}

variable "network_acl_tags" {
  description = "Additional tags for the Network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# NAT Gateway
################################################################################
