variable "create" {
  description = "Controls if network ACL resources should be created"
  type        = bool
  default     = true
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
  description = "The ID of the VPC to create the resources in"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "The IDs of the subnets to associate with the Network ACL created"
  type        = list(string)
  default     = []
}

variable "ingress_rules" {
  description = "Network ACL ingress rules to be added to the Network ACL"
  type        = map(any)
  default     = {}
}

variable "egress_rules" {
  description = "Network ACL egresss rules to be added to the Network ACL"
  type        = map(any)
  default     = {}
}
