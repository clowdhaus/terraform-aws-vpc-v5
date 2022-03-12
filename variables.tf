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

variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a `/56` prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is `false`. Conflicts with `ipv6_ipam_pool_id`"
  type        = bool
  default     = null
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC. Default is `default`, which makes your instances shared on the host"
  type        = string
  default     = null
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
  type        = any
  default     = {}
}

variable "ipv6_cidr_block_associations" {
  description = "Map of additional IPv6 CIDR blocks to associate with the VPC to extend the IP address pool"
  type        = any
  default     = {}
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

variable "dns_query_log_destintion_arn" {
  description = "The ARN of the resource that you want Route 53 Resolver to send query logs. You can send query logs to an S3 bucket, a CloudWatch Logs log group, or a Kinesis Data Firehose delivery stream"
  type        = string
  default     = null
}

################################################################################
# Flow Log
################################################################################

variable "create_flow_log" {
  description = "Controls if flow log for VPC is be created"
  type        = bool
  default     = false
}

variable "flow_log_destination_arn" {
  description = "The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create_flow_log_cloudwatch_log_group is set to false this argument must be provided."
  type        = string
  default     = ""
}

variable "flow_log_destination_type" {
  description = "Type of flow log destination. Can be s3 or cloud-watch-logs."
  type        = string
  default     = "cloud-watch-logs"
}

variable "flow_log_log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear."
  type        = string
  default     = null
}

variable "flow_log_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL."
  type        = string
  default     = "ALL"
}

variable "flow_log_max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds."
  type        = number
  default     = 600
}

variable "flow_log_file_format" {
  description = "The format for the flow log. Valid values: `plain-text`, `parquet`."
  type        = string
  default     = "plain-text"
}

variable "flow_log_hive_compatible_partitions" {
  description = "(Optional) Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3."
  type        = bool
  default     = false
}

variable "flow_log_per_hour_partition" {
  description = "(Optional) Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries."
  type        = bool
  default     = false
}

variable "flow_log_tags" {
  description = "Additional tags for the VPC Flow Logs"
  type        = map(string)
  default     = {}
}

################################################################################
# Flow Log CloudWatch Log Group
################################################################################

variable "create_flow_log_cloudwatch_log_group" {
  description = "Whether to create CloudWatch log group for VPC Flow Logs"
  type        = bool
  default     = false
}

variable "flow_log_cloudwatch_log_group_name_prefix" {
  description = "Specifies the name prefix of CloudWatch Log Group for VPC flow logs."
  type        = string
  default     = "/aws/vpc-flow-log/"
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group for VPC flow logs."
  type        = number
  default     = null
}

variable "flow_log_cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data for VPC flow logs."
  type        = string
  default     = null
}

################################################################################
# Flow Log CloudWatch Log Group IAM Role
################################################################################

variable "create_flow_log_cloudwatch_iam_role" {
  description = "Determines whether a an IAM role is created or to use an existing IAM role"
  type        = bool
  default     = true
}

variable "flow_log_cloudwatch_iam_role_arn" {
  description = "Existing IAM role ARN for the cluster. Required if `create_iam_role` is set to `false`"
  type        = string
  default     = null
}

variable "flow_log_iam_role_path" {
  description = "Cluster IAM role path"
  type        = string
  default     = null
}

variable "flow_log_iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "flow_log_iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
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
# Internet Gateway
################################################################################

variable "create_internet_gateway" {
  description = "Controls if an internet gateway is created"
  type        = bool
  default     = true
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

################################################################################
# Customer Gateway(s)
################################################################################

variable "customer_gateways" {
  description = "Map of Customer Gateway definitions to create"
  type        = any
  default     = {}
}

variable "customer_gateway_tags" {
  description = "Additional tags for the Customer Gateway(s)"
  type        = map(string)
  default     = {}
}

################################################################################
# VPN Gateway(s)
################################################################################

variable "vpn_gateways" {
  description = "Map of VPN Gateway definitions to create"
  type        = any
  default     = {}
}

variable "vpn_gateway_tags" {
  description = "Additional tags for the VPN Gateway(s)"
  type        = map(string)
  default     = {}
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
  description = "Ingress rules to be added to the Default Security Group"
  type        = list(map(string))
  default     = []
}

variable "default_security_group_egress_rules" {
  description = "Egress rules to be added to the Default Security Group"
  type        = list(map(string))
  default     = []
}

variable "default_security_group_tags" {
  description = "Additional tags for the Default Security Group"
  type        = map(string)
  default     = {}
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
  type        = list(map(string))
  default     = []
}

variable "default_network_acl_egress_rules" {
  description = "Egress rules to be added to the Default Network ACL"
  type        = list(map(string))
  default     = []
}

variable "default_network_acl_tags" {
  description = "Additional tags for the default network ACL"
  type        = map(string)
  default     = {}
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
  description = "Configuration block of routes. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table#route"
  type        = list(map(string))
  default     = []
}

variable "default_route_table_timeouts" {
  description = "Create and update timeout configurations for the default route table"
  type        = map(string)
  default     = {}
}

variable "default_route_table_tags" {
  description = "Additional tags for the default route table"
  type        = map(string)
  default     = {}
}

################################################################################
# Account Default DHCP Options
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

variable "default_vpc_tags" {
  description = "Additional tags for the Default VPC"
  type        = map(string)
  default     = {}
}
