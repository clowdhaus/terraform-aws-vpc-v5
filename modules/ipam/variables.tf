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

variable "create_ipam_pool" {
  description = "Controls if IPAM pool should be created"
  type        = bool
  default     = true
}

variable "pool_description" {
  description = "A description for the IPAM pool"
  type        = string
  default     = null
}

variable "pool_address_family" {
  description = "The IP protocol assigned to this pool. You must choose either IPv4 or IPv6 protocol for a pool: Defaults to `ipv4`"
  type        = string
  default     = "ipv4"
}

variable "pool_publicly_advertisable" {
  description = "Defines whether or not IPv6 pool space is publicly advertisable over the internet. This option is not available for IPv4 pool space"
  type        = bool
  default     = null
}

variable "pool_allocation_default_netmask_length" {
  description = "A default netmask length for allocations added to this pool"
  type        = number
  default     = null
}

variable "pool_allocation_max_netmask_length" {
  description = "The maximum netmask length that will be required for CIDR allocations in this pool"
  type        = number
  default     = null
}

variable "pool_allocation_min_netmask_length" {
  description = "The minimum netmask length that will be required for CIDR allocations in this pool"
  type        = number
  default     = null
}

variable "pool_allocation_resource_tags" {
  description = "Tags that are required for resources that use CIDRs from this IPAM pool. Resources that do not have these tags will not be allowed to allocate space from the pool. If the resources have their tags changed after they have allocated space or if the allocation tagging requirements are changed on the pool, the resource may be marked as noncompliant"
  type        = map(string)
  default     = {}
}

variable "pool_auto_import" {
  description = "If you include this argument, IPAM automatically imports any VPCs you have in your scope that fall within the CIDR range in the pool"
  type        = bool
  default     = null
}

variable "pool_aws_service" {
  description = "Limits which AWS service the pool can be used in. Only useable on public scopes. Valid Values: `ec2`"
  type        = string
  default     = null
}

variable "pool_use_private_scope" {
  description = "Controls if the pool scope used is private or public. If `false`, the IPAM default public scope is used"
  type        = bool
  default     = true
}

variable "pool_scope_key" {
  description = "The key within the `scopes` map to use for the pool scope"
  type        = string
  default     = null
}

variable "pool_locale" {
  description = "The locale in which you would like to create the IPAM pool. Locale is the Region where you want to make an IPAM pool available for allocations. You can only create pools with locales that match the operating Regions of the IPAM"
  type        = string
  default     = null
}

variable "pool_cidr" {
  description = "The CIDR you want to assign to the pool"
  type        = string
  default     = null
}

variable "pool_cidr_authorization_context" {
  description = "A signed document that proves that you are authorized to bring the specified IP address range to Amazon using BYOIP. This is not stored in the state file"
  type        = any
  default     = {}
}

variable "pool_cidr_allocations" {
  description = "A map of CIDR allocation definitions to allocate to the pool"
  type        = any
  default     = {}
}

variable "pool_preview_next_cidr" {
  description = "Controls whether to preview the next available CIDR in the pool"
  type        = bool
  default     = true
}

variable "pool_disallowed_cidrs" {
  description = "Exclude a particular CIDR range from being returned by the pool"
  type        = list(string)
  default     = []
}

variable "pool_preview_netmask_length" {
  description = "The netmask length of the CIDR you would like to preview from the IPAM pool"
  type        = number
  default     = null
}

variable "pool_tags" {
  description = "A map of additional tags to add to the IPAM pool"
  type        = map(string)
  default     = {}
}

################################################################################
# RAM Resource Association
################################################################################

variable "ram_resource_associations" {
  description = "A map of RAM resource associations for the created IPAM pool"
  type        = map(string)
  default     = {}
}
