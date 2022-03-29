variable "create" {
  description = "Controls if resources should be created; affects all resources"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# IPAM Pool
################################################################################

variable "description" {
  description = "A description for the IPAM pool"
  type        = string
  default     = null
}

variable "address_family" {
  description = "The IP protocol assigned to this pool. You must choose either IPv4 or IPv6 protocol for a pool: Defaults to `ipv4`"
  type        = string
  default     = "ipv4"
}

variable "publicly_advertisable" {
  description = "Defines whether or not IPv6 pool space is publicly advertisable over the internet. This option is not available for IPv4 pool space"
  type        = bool
  default     = null
}

variable "allocation_default_netmask_length" {
  description = "A default netmask length for allocations added to this pool"
  type        = number
  default     = null
}

variable "allocation_max_netmask_length" {
  description = "The maximum netmask length that will be required for CIDR allocations in this pool"
  type        = number
  default     = null
}

variable "allocation_min_netmask_length" {
  description = "The minimum netmask length that will be required for CIDR allocations in this pool"
  type        = number
  default     = null
}

variable "allocation_resource_tags" {
  description = "Tags that are required for resources that use CIDRs from this IPAM pool. Resources that do not have these tags will not be allowed to allocate space from the pool. If the resources have their tags changed after they have allocated space or if the allocation tagging requirements are changed on the pool, the resource may be marked as noncompliant"
  type        = map(string)
  default     = {}
}

variable "auto_import" {
  description = "If you include this argument, IPAM automatically imports any VPCs you have in your scope that fall within the CIDR range in the pool"
  type        = bool
  default     = null
}

variable "aws_service" {
  description = "Limits which AWS service the pool can be used in. Only useable on public scopes. Valid Values: `ec2`"
  type        = string
  default     = null
}

variable "ipam_scope_id" {
  description = "The ID of the scope in which you would like to create the IPAM pool"
  type        = string
  default     = null
}

variable "locale" {
  description = "The locale in which you would like to create the IPAM pool. Locale is the Region where you want to make an IPAM pool available for allocations. You can only create pools with locales that match the operating Regions of the IPAM"
  type        = string
  default     = null
}

variable "source_ipam_pool_id" {
  description = "The ID of the source IPAM pool. Use this argument to create a child pool within an existing pool"
  type        = string
  default     = null
}

################################################################################
# IPAM Pool CIDR
################################################################################

variable "cidr" {
  description = "The CIDR you want to assign to the pool"
  type        = string
  default     = null
}

variable "cidr_authorization_context" {
  description = "A signed document that proves that you are authorized to bring the specified IP address range to Amazon using BYOIP. This is not stored in the state file"
  type        = any
  default     = {}
}

################################################################################
# IPAM Pool Allocation
################################################################################

variable "cidr_allocations" {
  description = "A map of CIDR allocation definitions to allocate to the pool"
  type        = any
  default     = {}
}

################################################################################
# IPAM Preview Next CIDR
################################################################################

variable "preview_next_cidr" {
  description = "Controls whether to preview the next available CIDR in the pool"
  type        = bool
  default     = false
}

variable "disallowed_cidrs" {
  description = "Exclude a particular CIDR range from being returned by the pool"
  type        = list(string)
  default     = []
}

variable "preview_netmask_length" {
  description = "The netmask length of the CIDR you would like to preview from the IPAM pool"
  type        = number
  default     = null
}

################################################################################
# RAM Resource Association
################################################################################

variable "ram_resource_associations" {
  description = "A map of RAM resource associations for the created IPAM pool"
  type        = map(string)
  default     = {}
}
