variable "create" {
  description = "Controls if Network Firewall resources should be created"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Firewall Config
################################################################################
