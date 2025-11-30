# AWS VPC Terraform Module

:warning: Please do not rely on this being stable. The goal of this project is to explore changes to the upstream `terraform-aws-vpc` module and eventually land those changes there as v5.0. For now, this is just for exploring and open collaboration on what that next version might look like, and how users can migrate from v4.x to v5.x. Feel free to watch along if you are curious.

## Usage

See [`examples`](https://github.com/clowdhaus/terraform-aws-vpc-v5/tree/main/examples) directory for working examples to reference:

```hcl
module "vpc" {
  source = "clowdhaus/vpc-v5/aws"

  name                 = "example"
  cidr_block           = "10.99.0.0/16"
  enable_dns_hostnames = true

  ipv4_cidr_block_associations = {
    # This matches the provider API to avoid re-creating any existing associations
    "10.98.0.0/16" = {
      cidr_block = "10.98.0.0/16"
    }
  }

  # DNS Query Logging
  enable_dns_query_logging     = true
  dns_query_log_destintion_arn = "arn:aws:s3:::my-dns-query-log-bucket"

  # DHCP
  create_dhcp_options              = true
  dhcp_options_domain_name         = "us-east-1.compute.internal"
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]
  dhcp_options_ntp_servers         = ["169.254.169.123"]
  dhcp_options_netbios_node_type   = 2

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## High Level Diagram

<p align="center">
  <img src="https://github.com/clowdhaus/terraform-aws-vpc-v5/blob/main/.github/images/hld.svg" alt="high level diagram">
</p>

## Examples

Examples provided in [`examples`](https://github.com/clowdhaus/terraform-aws-vpc-v5/tree/main/examples) are intended to give users references for how to use the module(s) as well as testing/validating changes to the source code of the module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow maintainers to test your changes and to keep the examples up to date for users. Thank you!

- [Complete](https://github.com/clowdhaus/terraform-aws-vpc-v5/tree/main/examples/complete)
- [Default](https://github.com/clowdhaus/terraform-aws-vpc-v5/tree/main/examples/default)
- [IPAM](https://github.com/clowdhaus/terraform-aws-vpc-v5/tree/main/examples/ipam)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_customer_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_default_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl) | resource |
| [aws_default_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_egress_only_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_internet_gateway_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway_attachment) | resource |
| [aws_network_acl_rule.default_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.default_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_resolver_dnssec_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_dnssec_config) | resource |
| [aws_route53_resolver_firewall_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_config) | resource |
| [aws_route53_resolver_firewall_rule_group_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_rule_group_association) | resource |
| [aws_route53_resolver_query_log_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_query_log_config) | resource |
| [aws_route53_resolver_query_log_config_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_query_log_config_association) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_block_public_access_exclusion.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_block_public_access_exclusion) | resource |
| [aws_vpc_dhcp_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpc_ipv4_cidr_block_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association) | resource |
| [aws_vpc_ipv6_cidr_block_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv6_cidr_block_association) | resource |
| [aws_vpn_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#input\_assign\_generated\_ipv6\_cidr\_block) | Requests an Amazon-provided IPv6 CIDR block with a `/56` prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is `false`. Conflicts with `ipv6_ipam_pool_id` | `bool` | `null` | no |
| <a name="input_attach_internet_gateway"></a> [attach\_internet\_gateway](#input\_attach\_internet\_gateway) | Controls if an internet gateway is attached to the VPC | `bool` | `true` | no |
| <a name="input_block_public_access_exclusion"></a> [block\_public\_access\_exclusion](#input\_block\_public\_access\_exclusion) | Configuration for VPC Block Public Access exclusion | <pre>object({<br/>    internet_gateway_exclusion_mode = string<br/>  })</pre> | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if VPC should be created (it affects almost all resources) | `bool` | `true` | no |
| <a name="input_create_dns_query_log_config"></a> [create\_dns\_query\_log\_config](#input\_create\_dns\_query\_log\_config) | Controls if Route53 Resolver DNS Query Log Config is created. If `false`, then `dns_query_log_config_id` must be provided if `enable_dns_query_logging` is `true` | `bool` | `true` | no |
| <a name="input_create_egress_only_internet_gateway"></a> [create\_egress\_only\_internet\_gateway](#input\_create\_egress\_only\_internet\_gateway) | Controls if an egress only internet gateway is created | `bool` | `false` | no |
| <a name="input_create_internet_gateway"></a> [create\_internet\_gateway](#input\_create\_internet\_gateway) | Controls if an internet gateway is created | `bool` | `true` | no |
| <a name="input_customer_gateways"></a> [customer\_gateways](#input\_customer\_gateways) | Map of Customer Gateway definitions to create | <pre>map(object({<br/>    bgp_asn          = optional(string)<br/>    bgp_asn_extended = optional(string)<br/>    certificate_arn  = optional(string)<br/>    device_name      = optional(string)<br/>    ip_address       = optional(string)<br/>    type             = optional(string, "ipsec.1")<br/>  }))</pre> | `null` | no |
| <a name="input_default_network_acl_egress_rules"></a> [default\_network\_acl\_egress\_rules](#input\_default\_network\_acl\_egress\_rules) | Egress rules to be added to the Default Network ACL | <pre>map(object({<br/>    from_port       = optional(number)<br/>    icmp_code       = optional(number)<br/>    icmp_type       = optional(number)<br/>    ipv4_cidr_block = optional(string)<br/>    ipv6_cidr_block = optional(string)<br/>    protocol        = optional(string, "tcp")<br/>    rule_action     = string<br/>    to_port         = optional(number)<br/>  }))</pre> | `{}` | no |
| <a name="input_default_network_acl_ingress_rules"></a> [default\_network\_acl\_ingress\_rules](#input\_default\_network\_acl\_ingress\_rules) | Ingress rules to be added to the Default Network ACL | <pre>map(object({<br/>    from_port       = optional(number)<br/>    icmp_code       = optional(number)<br/>    icmp_type       = optional(number)<br/>    ipv4_cidr_block = optional(string)<br/>    ipv6_cidr_block = optional(string)<br/>    protocol        = optional(string, "tcp")<br/>    rule_action     = string<br/>    to_port         = optional(number)<br/>  }))</pre> | `{}` | no |
| <a name="input_default_route_table_propagating_vgws"></a> [default\_route\_table\_propagating\_vgws](#input\_default\_route\_table\_propagating\_vgws) | List of virtual gateways for propagation | `list(string)` | `[]` | no |
| <a name="input_default_route_table_routes"></a> [default\_route\_table\_routes](#input\_default\_route\_table\_routes) | Configuration block of routes. See [`route`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table#route) for more information | <pre>map(object({<br/>    destination_cidr_block      = optional(string)<br/>    destination_ipv6_cidr_block = optional(string)<br/>    destination_prefix_list_id  = optional(string)<br/>    # One of the following target arguments must be supplied:<br/>    carrier_gateway_id        = optional(string)<br/>    core_network_arn          = optional(string)<br/>    egress_only_gateway_id    = optional(string)<br/>    gateway_id                = optional(string)<br/>    local_gateway_id          = optional(string)<br/>    nat_gateway_id            = optional(string)<br/>    network_interface_id      = optional(string)<br/>    transit_gateway_id        = optional(string)<br/>    vpc_endpoint_id           = optional(string)<br/>    vpc_peering_connection_id = optional(string)<br/>  }))</pre> | `null` | no |
| <a name="input_default_route_table_timeouts"></a> [default\_route\_table\_timeouts](#input\_default\_route\_table\_timeouts) | Create and update timeout configurations for the default route table | <pre>object({<br/>    create = optional(string)<br/>    update = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_default_security_group_egress_rules"></a> [default\_security\_group\_egress\_rules](#input\_default\_security\_group\_egress\_rules) | Egress rules to be added to the Default Security Group. By default, the VPC added egress rule(s) are removed upon creation. This should not be used! Use custom security groups instead | <pre>list(object({<br/>    description      = optional(string)<br/>    from_port        = number<br/>    ipv4_cidr_blocks = optional(list(string))<br/>    ipv6_cidr_blocks = optional(list(string))<br/>    prefix_list_ids  = optional(list(string))<br/>    protocol         = string<br/>    security_groups  = optional(list(string))<br/>    self             = optional(bool)<br/>    to_port          = number<br/>  }))</pre> | `[]` | no |
| <a name="input_default_security_group_ingress_rules"></a> [default\_security\_group\_ingress\_rules](#input\_default\_security\_group\_ingress\_rules) | Ingress rules to be added to the Default Security Group. This should not be used! Use custom security groups instead | <pre>list(object({<br/>    description      = optional(string)<br/>    from_port        = number<br/>    ipv4_cidr_blocks = optional(list(string))<br/>    ipv6_cidr_blocks = optional(list(string))<br/>    prefix_list_ids  = optional(list(string))<br/>    protocol         = string<br/>    security_groups  = optional(list(string))<br/>    self             = optional(bool)<br/>    to_port          = number<br/>  }))</pre> | `[]` | no |
| <a name="input_dhcp_options"></a> [dhcp\_options](#input\_dhcp\_options) | Configuration block for custom DHCP options set. If `null`, no custom DHCP options set is created | <pre>object({<br/>    domain_name                       = optional(string)<br/>    domain_name_servers               = optional(list(string), ["AmazonProvidedDNS"])<br/>    ipv6_address_preferred_lease_time = optional(string)<br/>    netbios_name_servers              = optional(list(string))<br/>    netbios_node_type                 = optional(string)<br/>    ntp_servers                       = optional(list(string))<br/>    tags                              = optional(map(string), {})<br/>  })</pre> | `null` | no |
| <a name="input_dns_firewall_fail_open"></a> [dns\_firewall\_fail\_open](#input\_dns\_firewall\_fail\_open) | Determines how Route 53 Resolver handles queries during failures. Valid values: `ENABLED`, `DISABLED`. Defaults is `ENABLED` | `string` | `"ENABLED"` | no |
| <a name="input_dns_firewall_rule_group_associations"></a> [dns\_firewall\_rule\_group\_associations](#input\_dns\_firewall\_rule\_group\_associations) | Map of Route53 Resolver Firewall Rule Groups to associate with the VPC | <pre>map(object({<br/>    firewall_rule_group_id = string<br/>    mutation_protection    = optional(string)<br/>    name                   = optional(string)<br/>    priority               = number<br/>    tags                   = optional(map(string), {})<br/>  }))</pre> | `null` | no |
| <a name="input_dns_query_log_config_id"></a> [dns\_query\_log\_config\_id](#input\_dns\_query\_log\_config\_id) | The ID of an existing Route53 Resolver DNS Query Log Config to associate with the VPC | `string` | `null` | no |
| <a name="input_dns_query_log_destination_arn"></a> [dns\_query\_log\_destination\_arn](#input\_dns\_query\_log\_destination\_arn) | The ARN of the resource that you want Route 53 Resolver to send query logs. You can send query logs to an S3 bucket, a CloudWatch Logs log group, or a Kinesis Data Firehose delivery stream | `string` | `null` | no |
| <a name="input_enable_dns_firewall"></a> [enable\_dns\_firewall](#input\_enable\_dns\_firewall) | Controls if Route53 Resolver DNS Firewall is enabled/disabled | `bool` | `false` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | A boolean flag to enable/disable DNS hostnames in the VPC. Defaults `true` | `bool` | `true` | no |
| <a name="input_enable_dns_query_logging"></a> [enable\_dns\_query\_logging](#input\_enable\_dns\_query\_logging) | Controls if Route53 Resolver DNS Query Logging is enabled/disabled | `bool` | `false` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | A boolean flag to enable/disable DNS support in the VPC. Defaults `true` | `bool` | `null` | no |
| <a name="input_enable_dnssec_config"></a> [enable\_dnssec\_config](#input\_enable\_dnssec\_config) | Controls if Route53 Resolver DNSSEC Config is enabled/disabled | `bool` | `true` | no |
| <a name="input_enable_network_address_usage_metrics"></a> [enable\_network\_address\_usage\_metrics](#input\_enable\_network\_address\_usage\_metrics) | A boolean flag to enable/disable network address usage metrics in the VPC. Defaults `false` | `bool` | `null` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC. Default is `default`, which makes your instances shared on the host | `string` | `null` | no |
| <a name="input_internet_gateway_id"></a> [internet\_gateway\_id](#input\_internet\_gateway\_id) | The ID of an existing internet gateway to attach to the VPC. Required if `create_internet_gateway` is `false` and `attach_internet_gateway` is `true` | `string` | `null` | no |
| <a name="input_ipv4_cidr_block"></a> [ipv4\_cidr\_block](#input\_ipv4\_cidr\_block) | The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` | `string` | `null` | no |
| <a name="input_ipv4_cidr_block_associations"></a> [ipv4\_cidr\_block\_associations](#input\_ipv4\_cidr\_block\_associations) | Map of additional IPv4 CIDR blocks to associate with the VPC to extend the IP address pool | <pre>map(object({<br/>    cidr_block          = optional(string)<br/>    ipv4_ipam_pool_id   = optional(string)<br/>    ipv4_netmask_length = optional(number)<br/>    timeouts = optional(object({<br/>      create = optional(string)<br/>      delete = optional(string)<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_ipv4_ipam_pool_id"></a> [ipv4\_ipam\_pool\_id](#input\_ipv4\_ipam\_pool\_id) | The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR | `string` | `null` | no |
| <a name="input_ipv4_netmask_length"></a> [ipv4\_netmask\_length](#input\_ipv4\_netmask\_length) | The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a `ipv4_ipam_pool_id` | `number` | `null` | no |
| <a name="input_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#input\_ipv6\_cidr\_block) | IPv6 CIDR block to request from an IPAM Pool. Can be set explicitly or derived from IPAM using `ipv6_netmask_length` | `string` | `null` | no |
| <a name="input_ipv6_cidr_block_associations"></a> [ipv6\_cidr\_block\_associations](#input\_ipv6\_cidr\_block\_associations) | Map of additional IPv6 CIDR blocks to associate with the VPC to extend the IP address pool | <pre>map(object({<br/>    ipv6_cidr_block     = optional(string)<br/>    ipv6_ipam_pool_id   = optional(string)<br/>    ipv6_netmask_length = optional(number)<br/>    timeouts = optional(object({<br/>      create = optional(string)<br/>      delete = optional(string)<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_ipv6_cidr_block_network_border_group"></a> [ipv6\_cidr\_block\_network\_border\_group](#input\_ipv6\_cidr\_block\_network\_border\_group) | By default when an IPv6 CIDR is assigned to a VPC a default `ipv6_cidr_block_network_border_group` will be set to the region of the VPC | `string` | `null` | no |
| <a name="input_ipv6_ipam_pool_id"></a> [ipv6\_ipam\_pool\_id](#input\_ipv6\_ipam\_pool\_id) | IPAM Pool ID for a IPv6 pool. Conflicts with `assign_generated_ipv6_cidr_block` | `string` | `null` | no |
| <a name="input_ipv6_netmask_length"></a> [ipv6\_netmask\_length](#input\_ipv6\_netmask\_length) | Netmask length to request from IPAM Pool. Conflicts with `ipv6_cidr_block`. This can be omitted if IPAM pool as a `allocation_default_netmask_length` set. Valid values: `56` | `number` | `null` | no |
| <a name="input_manage_default_network_acl"></a> [manage\_default\_network\_acl](#input\_manage\_default\_network\_acl) | Determines whether the default network ACL is adopted and managed by the module | `bool` | `true` | no |
| <a name="input_manage_default_route_table"></a> [manage\_default\_route\_table](#input\_manage\_default\_route\_table) | Determines whether the default route table is adopted and managed by the module | `bool` | `true` | no |
| <a name="input_manage_default_security_group"></a> [manage\_default\_security\_group](#input\_manage\_default\_security\_group) | Determines whether the Default Security Group is adopted and managed by the module | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Additional tags for the VPC | `map(string)` | `{}` | no |
| <a name="input_vpn_gateways"></a> [vpn\_gateways](#input\_vpn\_gateways) | Map of VPN Gateway definitions to create | <pre>map(object({<br/>    amazon_side_asn   = optional(string)<br/>    availability_zone = optional(string)<br/>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of VPC |
| <a name="output_customer_gateway_arns"></a> [customer\_gateway\_arns](#output\_customer\_gateway\_arns) | List of Customer Gateways ARNs |
| <a name="output_customer_gateway_ids"></a> [customer\_gateway\_ids](#output\_customer\_gateway\_ids) | List of Customer Gateway IDs |
| <a name="output_customer_gateways"></a> [customer\_gateways](#output\_customer\_gateways) | Map of Customer Gateways and their attributes |
| <a name="output_default_network_acl_arn"></a> [default\_network\_acl\_arn](#output\_default\_network\_acl\_arn) | ARN of the Default Network ACL |
| <a name="output_default_network_acl_id"></a> [default\_network\_acl\_id](#output\_default\_network\_acl\_id) | ID of the Default Network ACL |
| <a name="output_default_route_table_arn"></a> [default\_route\_table\_arn](#output\_default\_route\_table\_arn) | ARN of the default route table |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | ID of the default route table |
| <a name="output_default_security_group_arn"></a> [default\_security\_group\_arn](#output\_default\_security\_group\_arn) | The ARN of the security group created by default on VPC creation |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_dhcp_options_arn"></a> [dhcp\_options\_arn](#output\_dhcp\_options\_arn) | The ARN of the DHCP options set |
| <a name="output_dhcp_options_association_id"></a> [dhcp\_options\_association\_id](#output\_dhcp\_options\_association\_id) | The ID of the DHCP Options set association |
| <a name="output_dhcp_options_id"></a> [dhcp\_options\_id](#output\_dhcp\_options\_id) | The ID of the DHCP options set |
| <a name="output_dns_firewall_config_id"></a> [dns\_firewall\_config\_id](#output\_dns\_firewall\_config\_id) | The ID of the firewall configuration |
| <a name="output_dns_firewall_rule_group_associations"></a> [dns\_firewall\_rule\_group\_associations](#output\_dns\_firewall\_rule\_group\_associations) | Map of Route53 resolver firewall rule group associations and their attributes |
| <a name="output_dns_query_log_config_arn"></a> [dns\_query\_log\_config\_arn](#output\_dns\_query\_log\_config\_arn) | The ARN (Amazon Resource Name) of the Route 53 Resolver query logging configuration |
| <a name="output_dns_query_log_config_association_id"></a> [dns\_query\_log\_config\_association\_id](#output\_dns\_query\_log\_config\_association\_id) | he ID of the Route 53 Resolver query logging configuration association |
| <a name="output_dns_query_log_config_id"></a> [dns\_query\_log\_config\_id](#output\_dns\_query\_log\_config\_id) | The ID of the Route 53 Resolver query logging configuration |
| <a name="output_dnssec_config_arn"></a> [dnssec\_config\_arn](#output\_dnssec\_config\_arn) | The ARN for a configuration for DNSSEC validation |
| <a name="output_dnssec_config_id"></a> [dnssec\_config\_id](#output\_dnssec\_config\_id) | The ID for a configuration for DNSSEC validation |
| <a name="output_egress_only_internet_gateway_id"></a> [egress\_only\_internet\_gateway\_id](#output\_egress\_only\_internet\_gateway\_id) | The ID of the Egress-Only Internet Gateway |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC |
| <a name="output_internet_gateway_arn"></a> [internet\_gateway\_arn](#output\_internet\_gateway\_arn) | The ARN of the Internet Gateway |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | The ID of the Internet Gateway |
| <a name="output_ipv4_cidr_block"></a> [ipv4\_cidr\_block](#output\_ipv4\_cidr\_block) | The IPv4 CIDR block of the VPC |
| <a name="output_ipv4_cidr_block_associations"></a> [ipv4\_cidr\_block\_associations](#output\_ipv4\_cidr\_block\_associations) | Map of IPv4 CIDR block associations and their attributes |
| <a name="output_ipv6_association_id"></a> [ipv6\_association\_id](#output\_ipv6\_association\_id) | The association ID for the IPv6 CIDR block |
| <a name="output_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#output\_ipv6\_cidr\_block) | The IPv6 CIDR block of the VPC |
| <a name="output_ipv6_cidr_block_associations"></a> [ipv6\_cidr\_block\_associations](#output\_ipv6\_cidr\_block\_associations) | Map of IPv6 CIDR block associations and their attributes |
| <a name="output_ipv6_cidr_block_network_border_group"></a> [ipv6\_cidr\_block\_network\_border\_group](#output\_ipv6\_cidr\_block\_network\_border\_group) | The Network Border Group Zone name |
| <a name="output_main_route_table_id"></a> [main\_route\_table\_id](#output\_main\_route\_table\_id) | The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an `aws_main_route_table_association` |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | The ID of the AWS account that owns the VPC |
| <a name="output_vpn_gateway_arns"></a> [vpn\_gateway\_arns](#output\_vpn\_gateway\_arns) | List of VPN Gateways ARNs |
| <a name="output_vpn_gateway_ids"></a> [vpn\_gateway\_ids](#output\_vpn\_gateway\_ids) | List of VPN Gateway IDs |
| <a name="output_vpn_gateways"></a> [vpn\_gateways](#output\_vpn\_gateways) | Map of VPN Gateways and their attributes |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-vpc-v5/blob/main/LICENSE).
