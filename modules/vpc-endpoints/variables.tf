variable "create" {
  description = "Determines whether resources will be created"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# VPC Endpoint(s)
################################################################################

variable "vpc_id" {
  description = "The ID of the VPC in which the endpoint will be used"
  type        = string
  default     = null
}

variable "vpc_endpoints" {
  description = "A map of interface and/or gateway VPC endpoints definitions to create"
  type        = any
  default     = {}
}

variable "vpc_endpoint_defaults" {
  description = "Map of VPC endpoint default configurations used across all endpoints created"
  type        = any
  default     = {}
}

variable "vpc_endpoint_timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting VPC endpoint resources"
  type        = map(string)
  default     = {}
}
