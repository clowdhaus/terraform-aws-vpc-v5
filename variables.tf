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

variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# VPC
################################################################################

variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a `/56` prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is `false`. Conflicts with `ipv6_ipam_pool_id`"
  type        = bool
  default     = null
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults `true`"
  type        = bool
  default     = null
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults `true`"
  type        = bool
  default     = true
}

variable "enable_network_address_usage_metrics" {
  description = "A boolean flag to enable/disable network address usage metrics in the VPC. Defaults `false`"
  type        = bool
  default     = null
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC. Default is `default`, which makes your instances shared on the host"
  type        = string
  default     = null
}

variable "ipv4_cidr_block" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length`"
  type        = string
  default     = null
}

variable "ipv4_ipam_pool_id" {
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR"
  type        = string
  default     = null
}

variable "ipv4_netmask_length" {
  description = "The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a `ipv4_ipam_pool_id`"
  type        = number
  default     = null
}

variable "ipv6_cidr_block" {
  description = "IPv6 CIDR block to request from an IPAM Pool. Can be set explicitly or derived from IPAM using `ipv6_netmask_length`"
  type        = string
  default     = null
}

variable "ipv6_ipam_pool_id" {
  description = "IPAM Pool ID for a IPv6 pool. Conflicts with `assign_generated_ipv6_cidr_block`"
  type        = string
  default     = null
}

variable "ipv6_netmask_length" {
  description = "Netmask length to request from IPAM Pool. Conflicts with `ipv6_cidr_block`. This can be omitted if IPAM pool as a `allocation_default_netmask_length` set. Valid values: `56`"
  type        = number
  default     = null
}

variable "ipv6_cidr_block_network_border_group" {
  description = "By default when an IPv6 CIDR is assigned to a VPC a default `ipv6_cidr_block_network_border_group` will be set to the region of the VPC"
  type        = string
  default     = null
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

################################################################################
# VPC CIDR Block Association(s)
################################################################################

variable "ipv4_cidr_block_associations" {
  description = "Map of additional IPv4 CIDR blocks to associate with the VPC to extend the IP address pool"
  type = map(object({
    cidr_block          = optional(string)
    ipv4_ipam_pool_id   = optional(string)
    ipv4_netmask_length = optional(number)
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
    }))
  }))
  default = null
}

variable "ipv6_cidr_block_associations" {
  description = "Map of additional IPv6 CIDR blocks to associate with the VPC to extend the IP address pool"
  type = map(object({
    ipv6_cidr_block     = optional(string)
    ipv6_ipam_pool_id   = optional(string)
    ipv6_netmask_length = optional(number)
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
    }))
  }))
  default = null
}

################################################################################
# VPC Block Public Access
################################################################################

variable "block_public_access_exclusion" {
  description = "Configuration for VPC Block Public Access exclusion"
  type = object({
    internet_gateway_exclusion_mode = string
  })
  default = null
}

################################################################################
# DHCP Options Set
################################################################################

variable "dhcp_options" {
  description = "Configuration block for custom DHCP options set. If `null`, no custom DHCP options set is created"
  type = object({
    domain_name                       = optional(string)
    domain_name_servers               = optional(list(string), ["AmazonProvidedDNS"])
    ipv6_address_preferred_lease_time = optional(string)
    netbios_name_servers              = optional(list(string))
    netbios_node_type                 = optional(string)
    ntp_servers                       = optional(list(string))
    tags                              = optional(map(string), {})
  })
  default = null
}

################################################################################
# Internet Gateway
################################################################################

variable "create_internet_gateway" {
  description = "Controls if an internet gateway is created"
  type        = bool
  default     = true
}

variable "attach_internet_gateway" {
  description = "Controls if an internet gateway is attached to the VPC"
  type        = bool
  default     = true
}

variable "internet_gateway_id" {
  description = "The ID of an existing internet gateway to attach to the VPC. Required if `create_internet_gateway` is `false` and `attach_internet_gateway` is `true`"
  type        = string
  default     = null
}

variable "create_egress_only_internet_gateway" {
  description = "Controls if an egress only internet gateway is created"
  type        = bool
  default     = false
}

################################################################################
# Customer Gateway(s)
################################################################################

variable "customer_gateways" {
  description = "Map of Customer Gateway definitions to create"
  type = map(object({
    bgp_asn          = optional(string)
    bgp_asn_extended = optional(string)
    certificate_arn  = optional(string)
    device_name      = optional(string)
    ip_address       = optional(string)
    type             = optional(string, "ipsec.1")
  }))
  default = null
}

################################################################################
# VPN Gateway(s)
################################################################################

variable "vpn_gateways" {
  description = "Map of VPN Gateway definitions to create"
  type = map(object({
    amazon_side_asn   = optional(string)
    availability_zone = optional(string)
  }))
  default = null
}

################################################################################
# Route53 Resolver
################################################################################

variable "enable_dnssec_config" {
  description = "Controls if Route53 Resolver DNSSEC Config is enabled/disabled"
  type        = bool
  default     = true
}

variable "enable_dns_query_logging" {
  description = "Controls if Route53 Resolver DNS Query Logging is enabled/disabled"
  type        = bool
  default     = false
}

variable "create_dns_query_log_config" {
  description = "Controls if Route53 Resolver DNS Query Log Config is created. If `false`, then `dns_query_log_config_id` must be provided if `enable_dns_query_logging` is `true`"
  type        = bool
  default     = true
}

variable "dns_query_log_config_id" {
  description = "The ID of an existing Route53 Resolver DNS Query Log Config to associate with the VPC"
  type        = string
  default     = null
}

variable "dns_query_log_destination_arn" {
  description = "The ARN of the resource that you want Route 53 Resolver to send query logs. You can send query logs to an S3 bucket, a CloudWatch Logs log group, or a Kinesis Data Firehose delivery stream"
  type        = string
  default     = null
}

################################################################################
# DNS Firewall Rule Group Association
################################################################################

variable "enable_dns_firewall" {
  description = "Controls if Route53 Resolver DNS Firewall is enabled/disabled"
  type        = bool
  default     = false
}

variable "dns_firewall_fail_open" {
  description = "Determines how Route 53 Resolver handles queries during failures. Valid values: `ENABLED`, `DISABLED`. Defaults is `ENABLED`"
  type        = string
  default     = "ENABLED"
}

variable "dns_firewall_rule_group_associations" {
  description = "Map of Route53 Resolver Firewall Rule Groups to associate with the VPC"
  type = map(object({
    firewall_rule_group_id = string
    mutation_protection    = optional(string)
    name                   = optional(string)
    priority               = number
    tags                   = optional(map(string), {})
  }))
  default = null
}

################################################################################
# VPC Default Security Group
################################################################################

variable "manage_default_security_group" {
  description = "Determines whether the Default Security Group is adopted and managed by the module"
  type        = bool
  default     = true
}

variable "default_security_group_ingress_rules" {
  description = "Ingress rules to be added to the Default Security Group. This should not be used! Use custom security groups instead"
  type = list(object({
    description      = optional(string)
    from_port        = number
    ipv4_cidr_blocks = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    protocol         = string
    security_groups  = optional(list(string))
    self             = optional(bool)
    to_port          = number
  }))
  default  = []
  nullable = false
}

variable "default_security_group_egress_rules" {
  description = "Egress rules to be added to the Default Security Group. By default, the VPC added egress rule(s) are removed upon creation. This should not be used! Use custom security groups instead"
  type = list(object({
    description      = optional(string)
    from_port        = number
    ipv4_cidr_blocks = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    protocol         = string
    security_groups  = optional(list(string))
    self             = optional(bool)
    to_port          = number
  }))
  default  = []
  nullable = false
}

################################################################################
# VPC Default Network ACL
################################################################################

variable "manage_default_network_acl" {
  description = "Determines whether the default network ACL is adopted and managed by the module"
  type        = bool
  default     = true
}

variable "default_network_acl_ingress_rules" {
  description = "Ingress rules to be added to the Default Network ACL"
  type = map(object({
    from_port       = optional(number)
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv4_cidr_block = optional(string)
    ipv6_cidr_block = optional(string)
    protocol        = optional(string, "tcp")
    rule_action     = string
    to_port         = optional(number)
  }))
  default  = {}
  nullable = false
}

variable "default_network_acl_egress_rules" {
  description = "Egress rules to be added to the Default Network ACL"
  type = map(object({
    from_port       = optional(number)
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv4_cidr_block = optional(string)
    ipv6_cidr_block = optional(string)
    protocol        = optional(string, "tcp")
    rule_action     = string
    to_port         = optional(number)
  }))
  default  = {}
  nullable = false
}

################################################################################
# VPC Default Route Table
################################################################################

variable "manage_default_route_table" {
  description = "Determines whether the default route table is adopted and managed by the module"
  type        = bool
  default     = true
}

variable "default_route_table_propagating_vgws" {
  description = "List of virtual gateways for propagation"
  type        = list(string)
  default     = []
}

variable "default_route_table_routes" {
  description = "Configuration block of routes. See [`route`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table#route) for more information"
  type = map(object({
    destination_cidr_block      = optional(string)
    destination_ipv6_cidr_block = optional(string)
    destination_prefix_list_id  = optional(string)
    # One of the following target arguments must be supplied:
    carrier_gateway_id        = optional(string)
    core_network_arn          = optional(string)
    egress_only_gateway_id    = optional(string)
    gateway_id                = optional(string)
    local_gateway_id          = optional(string)
    nat_gateway_id            = optional(string)
    network_interface_id      = optional(string)
    transit_gateway_id        = optional(string)
    vpc_endpoint_id           = optional(string)
    vpc_peering_connection_id = optional(string)
  }))
  default = null
}

variable "default_route_table_timeouts" {
  description = "Create and update timeout configurations for the default route table"
  type = object({
    create = optional(string)
    update = optional(string)
  })
  default = null
}
