variable "create" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# VPC
################################################################################

# VPC
variable "cidr_block" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC. Default is `default`, which makes your instances shared on the host"
  type        = string
  default     = "default"
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults `true`"
  type        = bool
  default     = null
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults `false`"
  type        = bool
  default     = null
}

variable "enable_classiclink" {
  description = "A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic"
  type        = bool
  default     = null
}

variable "enable_classiclink_dns_support" {
  description = "A boolean flag to enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic"
  type        = bool
  default     = null
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is `false`"
  type        = bool
  default     = null
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

# Associate additional CIDR blocks
variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool"
  type        = list(string)
  default     = []
}

################################################################################
# DHCP Options Set
################################################################################

variable "create_dhcp_options" {
  description = "Controls if custom DHCP options set is created"
  type        = bool
  default     = false
}

variable "dhcp_options_domain_name" {
  description = "The suffix domain name to use by default when resolving non fully qualified domain names"
  type        = string
  default     = null
}

variable "dhcp_options_domain_name_servers" {
  description = "List of name servers to configure in `/etc/resolv.conf`"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = "List of NTP servers to configure"
  type        = list(string)
  default     = null
}

variable "dhcp_options_netbios_name_servers" {
  description = "List of NETBIOS name servers"
  type        = list(string)
  default     = null
}

variable "dhcp_options_netbios_node_type" {
  description = "The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network"
  type        = number
  default     = null
}

variable "dhcp_options_tags" {
  description = "Additional tags for the DHCP option set"
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
# Default Security Group for VPC created
################################################################################

variable "manage_default_security_group" {
  description = "Determines whether the default security group is adopted and managed by the module"
  type        = bool
  default     = true
}

variable "default_security_group_name" {
  description = "Name to be used on the default security group"
  type        = string
  default     = ""
}

variable "default_security_group_ingress" {
  description = "List of maps of ingress rules to set on the default security group"
  type        = list(map(string))
  default     = []
}

variable "default_security_group_egress" {
  description = "List of maps of egress rules to set on the default security group"
  type        = list(map(string))
  default     = []
}

variable "default_security_group_tags" {
  description = "Additional tags for the default security group"
  type        = map(string)
  default     = {}
}

################################################################################
# Default Network ACL for VPC created
################################################################################

variable "manage_default_network_acl" {
  description = "Determines whether the default network ACL is adopted and managed by the module"
  type        = bool
  default     = false
}

variable "default_network_acl_name" {
  description = "Name to be used on the default network ACL"
  type        = string
  default     = ""
}

variable "default_network_acl_ingress" {
  description = "List of maps for ingress rules to set on the default network ACL"
  type        = list(map(string))
  default     = []
}

variable "default_network_acl_egress" {
  description = "List of maps for egress rules to set on the default network ACL"
  type        = list(map(string))
  default     = []
}

variable "default_network_acl_tags" {
  description = "Additional tags for the default network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# Default Route Table for VPC created
################################################################################

variable "manage_default_route_table" {
  description = "Determines whether the default route table is adopted and managed by the module"
  type        = bool
  default     = false
}

variable "default_route_table_propagating_vgws" {
  description = "List of virtual gateways for propagation"
  type        = list(string)
  default     = []
}

variable "default_route_table_routes" {
  description = "Configuration block of routes. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table#route"
  type        = list(map(string))
  default     = []
}

variable "default_route_table_timeouts" {
  description = "Create and update timeout configurations for the default route table"
  type        = map(string)
  default     = {}
}

variable "default_route_table_name" {
  description = "Name to be used on the default route table"
  type        = string
  default     = ""
}
variable "default_route_table_tags" {
  description = "Additional tags for the default route table"
  type        = map(string)
  default     = {}
}

################################################################################
# Default DHCP Options
################################################################################

variable "manage_default_dhcp_options" {
  description = "Determines whether the default DHCP options are adopted and managed by the module"
  type        = bool
  default     = false
}

variable "default_dhcp_options_netbios_name_servers" {
  description = "List of NETBIOS name servers"
  type        = list(string)
  default     = null
}

variable "default_dhcp_options_netbios_node_type" {
  description = " The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network"
  type        = number
  default     = null
}

variable "default_dhcp_options_owner_id" {
  description = "The ID of the AWS account that owns the DHCP options set"
  type        = string
  default     = null
}

variable "default_dhcp_options_name" {
  description = "Name to be used on the default DHCP options"
  type        = string
  default     = ""
}

variable "default_dhcp_options_tags" {
  description = "Additional tags for the default DHCP options"
  type        = map(string)
  default     = {}
}

################################################################################
# Account Default VPC
################################################################################

variable "manage_default_vpc" {
  description = "Determines whether the default VPC is adopted and managed by the module"
  type        = bool
  default     = false
}

variable "default_vpc_enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults `true`"
  type        = bool
  default     = null
}

variable "default_vpc_enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults `false`"
  type        = bool
  default     = null
}

variable "default_vpc_enable_classiclink" {
  description = "A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic"
  type        = bool
  default     = null
}

variable "default_vpc_name" {
  description = "Name to be used on the Default VPC"
  type        = string
  default     = ""
}

variable "default_vpc_tags" {
  description = "Additional tags for the Default VPC"
  type        = map(string)
  default     = {}
}
