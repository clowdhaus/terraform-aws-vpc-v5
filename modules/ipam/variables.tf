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
# IPAM
################################################################################
