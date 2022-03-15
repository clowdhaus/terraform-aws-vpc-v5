variable "create" {
  description = "Controls if resources should be created"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Route Table
################################################################################

variable "name" {
  description = "Route table name"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The ID of the VPC to create the route table within"
  type        = string
  default     = ""
}

variable "timeouts" {
  description = "Create, update, and delete timeout configurations for route table"
  type        = map(string)
  default     = {}
}

################################################################################
# Routes
################################################################################

variable "routes" {
  description = "Map of route definitions to create"
  type        = map(any)
  default     = {}
}

variable "route_timeouts" {
  description = "Create, update, and delete timeout configurations for routes"
  type        = map(string)
  default     = {}
}

################################################################################
# Route Table Association
# See `subnets` sub-module for associating to subnet
################################################################################

variable "associated_gateway_ids" {
  description = "The IDs of the gateways to associate with the route table"
  type        = list(string)
  default     = []
}
