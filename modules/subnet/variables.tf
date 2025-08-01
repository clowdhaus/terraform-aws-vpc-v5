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

variable "vpc_id" {
  description = "The ID of the VPC the resources are created within"
  type        = string
  default     = ""
}

################################################################################
# Subnet
################################################################################

variable "availability_zone" {
  description = "AZ for the subnet"
  type        = string
  default     = null
}

variable "availability_zone_id" {
  description = "AZ ID of the subnet. This argument is not supported in all regions or partitions. If necessary, use `availability_zone` instead"
  type        = string
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

variable "private_dns_hostname_type_on_launch" {
  description = "The type of hostnames to assign to instances in the subnet at launch. For IPv6-only subnets, an instance DNS name must be based on the instance ID. For dual-stack and IPv4-only subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID"
  type        = string
  default     = null
}

variable "ipv4_cidr_block" {
  description = "The IPv4 CIDR block for the subnet"
  type        = string
  default     = null
}

variable "customer_owned_ipv4_pool" {
  description = "The customer owned IPv4 address pool. Typically used with the `map_customer_owned_ip_on_launch` argument. The `outpost_arn` argument must be specified when configured"
  type        = string
  default     = null
}

variable "ipv6_cidr_block" {
  description = "The IPv6 network range for the subnet, in CIDR notation. The subnet size must use a /64 prefix length"
  type        = string
  default     = null
}

variable "ipv6_native" {
  description = "Indicates whether to create an IPv6-only subnet"
  type        = bool
  default     = null
}

variable "assign_ipv6_address_on_creation" {
  description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address"
  type        = bool
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

variable "enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records"
  type        = bool
  default     = null
}

variable "enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records"
  type        = bool
  default     = null
}

variable "outpost_arn" {
  description = "The Amazon Resource Name (ARN) of the Outpost"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Create and delete timeout configurations for subnet"
  type        = map(string)
  default     = {}
}

################################################################################
# EC2 Subnet CIDR Reservation
################################################################################

variable "cidr_reservations" {
  description = "Map of CIDR reservations to create"
  type        = any
  default     = {}
}

################################################################################
# RAM Resource Association
################################################################################

variable "share_subnet" {
  description = "Controls if the subnet should be shared via RAM resource association"
  type        = bool
  default     = false
}

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

variable "route_table_id" {
  description = "The ID of an existing route table to associate with the subnet"
  type        = string
  default     = null
}

variable "route_table_timeouts" {
  description = "Create, update, and delete timeout configurations for route table"
  type        = map(string)
  default     = {}
}

variable "route_table_tags" {
  description = "Additional tags for the VPC"
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

################################################################################
# Route Table Association
################################################################################

variable "associated_gateways" {
  description = "Map of gateways to associate with the route table"
  type        = map(string)
  default     = {}
}

variable "route_table_association_timeouts" {
  description = "Create, update, and delete timeout configurations for route table association"
  type        = map(string)
  default     = {}
}

################################################################################
# NAT Gateway
################################################################################

variable "create_nat_gateway" {
  description = "Controls if a NAT gateway should be created"
  type        = bool
  default     = true
}

variable "create_eip" {
  description = "Controls if an EIP should be created for the NAT gateway"
  type        = bool
  default     = true
}

variable "eip_address" {
  description = "IP address from an EC2 BYOIP pool"
  type        = string
  default     = null
}

variable "eip_associate_with_private_ip" {
  description = "User-specified primary or secondary private IP address to associate with the Elastic IP address. If no private IP address is specified, the Elastic IP address is associated with the primary private IP address"
  type        = bool
  default     = null
}

variable "eip_customer_owned_ipv4_pool" {
  description = "ID of a customer-owned address pool"
  type        = string
  default     = null
}

variable "eip_network_border_group" {
  description = "Location from which the IP address is advertised. Use this parameter to limit the address to this location"
  type        = string
  default     = null
}

variable "eip_public_ipv4_pool" {
  description = "EC2 IPv4 address pool identifier or `amazon`"
  type        = string
  default     = null
}

variable "nat_gateway_allocation_id" {
  description = "The Allocation ID of the Elastic IP address for the gateway. Required when `nat_gateway_connectivity_type` is `public` and `create_eip` is `false`"
  type        = string
  default     = null
}

variable "nat_gateway_connectivity_type" {
  description = "Connectivity type for the gateway. Valid values are `private` and `public`. Defaults to `public`"
  type        = string
  default     = null
}

variable "nat_gateway_tags" {
  description = "Additional tags for the NAT gateway"
  type        = map(string)
  default     = {}
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
  description = "The ID of an existing internet gateway to attach to the VPC. Reqiured if `create_internet_gateway` is `false` and `attach_internet_gateway` is `true`"
  type        = string
  default     = null
}

variable "create_egress_only_internet_gateway" {
  description = "Controls if an egress only internet gateway is created"
  type        = bool
  default     = false
}

variable "internet_gateway_tags" {
  description = "Additional tags for the internet gateway/egress only internet gateway"
  type        = map(string)
  default     = {}
}
