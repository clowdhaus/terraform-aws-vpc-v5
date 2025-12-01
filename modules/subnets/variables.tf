variable "create" {
  description = "Controls if resources should be created"
  type        = bool
  default     = true
}

variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "name" {
  description = "Name used across the resources created"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Subnet(s)
################################################################################

variable "subnets" {
  description = "Map of subnet definitions to create"
  type = map(object({
    availability_zone    = optional(string)
    availability_zone_id = optional(string)
    ipv4_cidr_block      = optional(string)
    ipv6_cidr_block      = optional(string)

    # Subnet CIDR Reservation
    cidr_reservations = optional(map(object({
      cidr_block       = string
      description      = optional(string)
      reservation_type = string
    })))

    # Route Table Association
    route_table_id = optional(string)
  }))
  default  = {}
  nullable = false
}

variable "assign_ipv6_address_on_creation" {
  description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address"
  type        = bool
  default     = null
}

variable "customer_owned_ipv4_pool" {
  description = "The customer owned IPv4 address pool. Typically used with the `map_customer_owned_ip_on_launch` argument. The `outpost_arn` argument must be specified when configured"
  type        = string
  default     = null
}

variable "enable_dns64" {
  description = "Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations"
  type        = bool
  default     = null
}

variable "enable_lni_at_device_index" {
  description = "Indicates the device position for local network interfaces in this subnet"
  type        = number
  default     = null
}

variable "enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records"
  type        = bool
  default     = null
}

variable "enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records"
  type        = bool
  default     = null
}

variable "ipv6_native" {
  description = "Indicates whether to create an IPv6-only subnet"
  type        = bool
  default     = null
}

variable "map_customer_owned_ip_on_launch" {
  description = "Specify true to indicate that network interfaces created in the subnet should be assigned a customer owned IP address. The `customer_owned_ipv4_pool` and `outpost_arn` arguments must be specified when set to `true`"
  type        = bool
  default     = null
}

variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address"
  type        = bool
  default     = null
}

variable "outpost_arn" {
  description = "The Amazon Resource Name (ARN) of the Outpost"
  type        = string
  default     = null
}

variable "private_dns_hostname_type_on_launch" {
  description = "The type of hostnames to assign to instances in the subnet at launch. For IPv6-only subnets, an instance DNS name must be based on the instance ID. For dual-stack and IPv4-only subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The ID of the VPC the resources are created within"
  type        = string
  default     = ""
}

variable "timeouts" {
  description = "Create and delete timeout configurations for subnet"
  type = object({
    create = optional(string)
    delete = optional(string)
  })
  default = null
}

################################################################################
# RAM Resource Association
################################################################################

variable "resource_share_arn" {
  description = "Amazon Resource Name (ARN) of the RAM Resource Share"
  type        = string
  default     = null
}

################################################################################
# Route Table
################################################################################

variable "create_route_table" {
  description = "Controls if a route table should be created"
  type        = bool
  default     = true
}

variable "route_table_propagating_vgws" {
  description = "List of virtual gateways for route propagation"
  type        = list(string)
  default     = []
}

variable "route_table_timeouts" {
  description = "Create, update, and delete timeout configurations for route table"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

variable "route_table_tags" {
  description = "Additional tags for the route table"
  type        = map(string)
  default     = {}
}

################################################################################
# Routes
################################################################################

variable "routes" {
  description = "Map of route definitions to create"
  type = map(object({
    destination_ipv4_cidr_block = optional(string)
    destination_ipv6_cidr_block = optional(string)
    destination_prefix_list_id  = optional(string)
    carrier_gateway_id          = optional(string)
    core_network_arn            = optional(string)
    egress_only_gateway_id      = optional(string)
    gateway_id                  = optional(string)
    local_gateway_id            = optional(string)
    nat_gateway_id              = optional(string)
    network_interface_id        = optional(string)
    transit_gateway_id          = optional(string)
    vpc_endpoint_id             = optional(string)
    vpc_peering_connection_id   = optional(string)
    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
  }))
  default = null
}

################################################################################
# Route Table Association
################################################################################

variable "associated_gateways" {
  description = "Map of gateways to associate with the route table"
  type = map(object({
    gateway_id = string
    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
  }))
  default = null
}

################################################################################
# NAT Gateway
################################################################################

variable "nat_gateway" {
  description = "Configuration for the NAT gateway to create in the subnet. Set to `null` to not create a NAT gateway"
  type = object({
    connectivity_type                  = optional(string)
    private_ip                         = optional(string)
    secondary_private_ip_address_count = optional(number)
    secondary_private_ip_addresses     = optional(list(string))
    tags                               = optional(map(string), {})

    # EIP(s)
    eips = optional(map(object({
      address                   = optional(string)
      associate_with_private_ip = optional(bool)
      customer_owned_ipv4_pool  = optional(string)
      ipam_pool_id              = optional(string)
      network_border_group      = optional(string)
      public_ipv4_pool          = optional(string)
    })))
  })
  # Creates one NAT gateway w/ an EIP by default
  default = {
    eips = {
      default = {}
    }
  }
}
