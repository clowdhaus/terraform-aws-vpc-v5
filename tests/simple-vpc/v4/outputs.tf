output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.vpc.default_security_group_id
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = module.vpc.default_network_acl_id
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = module.vpc.default_route_table_id
}

# output "vpc_instance_tenancy" {
#   description = "Tenancy of instances spin up within VPC"
#   value       = module.vpc.instance_tenancy
# }

# output "vpc_enable_dns_support" {
#   description = "Whether or not the VPC has DNS support"
#   value       = module.vpc.enable_dns_support
# }

# output "vpc_enable_dns_hostnames" {
#   description = "Whether or not the VPC has DNS hostname support"
#   value       = module.vpc.enable_dns_hostnames
# }

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = module.vpc.main_route_table_id
}

# output "vpc_ipv6_association_id" {
#   description = "The association ID for the IPv6 CIDR block"
#   value       = module.vpc.ipv6_association_id
# }

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = module.vpc.ipv6_cidr_block
}

# output "vpc_secondary_cidr_blocks" {
#   description = "List of secondary CIDR blocks of the VPC"
#   value       = module.vpc.secondary_cidr_blocks
# }

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = module.vpc.owner_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.private_subnets.ids
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.private_subnets.arns
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.private_subnets.ipv4_cidr_blocks
}

output "private_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC"
  value       = module.private_subnets.ipv6_cidr_blocks
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.public_subnets.ids
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = module.public_subnets.arns
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.public_subnets.ipv4_cidr_blocks
}

output "public_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = module.public_subnets.ipv6_cidr_blocks
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.public_subnets.route_table_ids
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.private_subnets.route_table_ids
}

# output "public_internet_gateway_route_id" {
#   description = "ID of the internet gateway route"
#   value       = module.vpc.public_internet_gateway_route_id
# }

# output "public_internet_gateway_ipv6_route_id" {
#   description = "ID of the IPv6 internet gateway route"
#   value       = module.vpc.public_internet_gateway_ipv6_route_id
# }

# output "private_nat_gateway_route_ids" {
#   description = "List of IDs of the private nat gateway route"
#   value       = module.vpc.private_nat_gateway_route_ids
# }

# output "private_ipv6_egress_route_ids" {
#   description = "List of IDs of the ipv6 egress route"
#   value       = module.vpc.private_ipv6_egress_route_ids
# }

output "private_route_table_association_ids" {
  description = "List of IDs of the private route table association"
  value       = module.private_subnets.route_table_subnet_association_ids
}

output "public_route_table_association_ids" {
  description = "List of IDs of the public route table association"
  value       = module.public_subnets.route_table_subnet_association_ids
}

# output "dhcp_options_id" {
#   description = "The ID of the DHCP options"
#   value       = module.vpc.dhcp_options_id
# }

# output "nat_ids" {
#   description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
#   value       = module.vpc.nat_ids
# }

# output "nat_public_ips" {
#   description = "List of public Elastic IPs created for AWS NAT Gateway"
#   value       = module.vpc.nat_public_ips
# }

# output "natgw_ids" {
#   description = "List of NAT Gateway IDs"
#   value       = module.vpc.natgw_ids
# }

# output "igw_id" {
#   description = "The ID of the Internet Gateway"
#   value       = module.vpc.igw_id
# }

# output "igw_arn" {
#   description = "The ARN of the Internet Gateway"
#   value       = module.vpc.igw_arn
# }

# output "egress_only_internet_gateway_id" {
#   description = "The ID of the egress only Internet Gateway"
#   value       = module.vpc.egress_only_internet_gateway_id
# }

# output "cgw_ids" {
#   description = "List of IDs of Customer Gateway"
#   value       = module.vpc.cgw_ids
# }

# output "cgw_arns" {
#   description = "List of ARNs of Customer Gateway"
#   value       = module.vpc.cgw_arns
# }

# output "this_customer_gateway" {
#   description = "Map of Customer Gateway attributes"
#   value       = module.vpc.this_customer_gateway
# }

# output "vgw_id" {
#   description = "The ID of the VPN Gateway"
#   value       = module.vpc.vgw_id
# }

# output "vgw_arn" {
#   description = "The ARN of the VPN Gateway"
#   value       = module.vpc.vgw_arn
# }

# output "default_vpc_id" {
#   description = "The ID of the Default VPC"
#   value       = module.vpc.default_vpc_id
# }

# output "default_vpc_arn" {
#   description = "The ARN of the Default VPC"
#   value       = module.vpc.default_vpc_arn
# }

# output "default_vpc_cidr_block" {
#   description = "The CIDR block of the Default VPC"
#   value       = module.vpc.default_vpc_cidr_block
# }

# output "default_vpc_default_security_group_id" {
#   description = "The ID of the security group created by default on Default VPC creation"
#   value       = module.vpc.default_vpc_default_security_group_id
# }

# output "default_vpc_default_network_acl_id" {
#   description = "The ID of the default network ACL of the Default VPC"
#   value       = module.vpc.default_vpc_default_network_acl_id
# }

# output "default_vpc_default_route_table_id" {
#   description = "The ID of the default route table of the Default VPC"
#   value       = module.vpc.default_vpc_default_route_table_id
# }

# output "default_vpc_instance_tenancy" {
#   description = "Tenancy of instances spin up within Default VPC"
#   value       = module.vpc.default_vpc_instance_tenancy
# }

# output "default_vpc_enable_dns_support" {
#   description = "Whether or not the Default VPC has DNS support"
#   value       = module.vpc.default_vpc_enable_dns_support
# }

# output "default_vpc_enable_dns_hostnames" {
#   description = "Whether or not the Default VPC has DNS hostname support"
#   value       = module.vpc.default_vpc_enable_dns_hostnames
# }

# output "default_vpc_main_route_table_id" {
#   description = "The ID of the main route table associated with the Default VPC"
#   value       = module.vpc.default_vpc_main_route_table_id
# }

# output "public_network_acl_id" {
#   description = "ID of the public network ACL"
#   value       = module.vpc.public_network_acl_id
# }

# output "public_network_acl_arn" {
#   description = "ARN of the public network ACL"
#   value       = module.vpc.public_network_acl_arn
# }

# output "private_network_acl_id" {
#   description = "ID of the private network ACL"
#   value       = module.vpc.private_network_acl_id
# }

# output "private_network_acl_arn" {
#   description = "ARN of the private network ACL"
#   value       = module.vpc.private_network_acl_arn
# }

# # VPC flow log
# output "vpc_flow_log_id" {
#   description = "The ID of the Flow Log resource"
#   value       = module.vpc.vpc_flow_log_id
# }

# output "vpc_flow_log_destination_arn" {
#   description = "The ARN of the destination for VPC Flow Logs"
#   value       = module.vpc.vpc_flow_log_destination_arn
# }

# output "vpc_flow_log_destination_type" {
#   description = "The type of the destination for VPC Flow Logs"
#   value       = module.vpc.vpc_flow_log_destination_type
# }

# output "vpc_flow_log_cloudwatch_iam_role_arn" {
#   description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
#   value       = module.vpc.vpc_flow_log_cloudwatch_iam_role_arn
# }
