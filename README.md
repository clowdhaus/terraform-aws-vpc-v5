# AWS VPC Terraform module

:warning: This is experimental only - please do not rely on this being stable at this time. The goal of this project is to explore changes to the upstream `terraform-aws-vpc` module and hopefully/eventually land those changes there as v4.0. For now, this is just for testing and open collaboration on what that next version might look like, and how users can migrate from v3.x to v4.x

## Design Goals

- Terraform v1.x is min supported now that its GA
- Use of maps/`for_each` over `count` for stable/isolated changes
- n-number of subnet groups with custom naming scheme
  - Currently only `private`, `public`, `internal`, `database`, and `redshift` are permitted and using those names
- Ability to stack CIDR ranges - AWS allows up to 5 CIDR ranges to be stacked on a VPC
- Changing between 1 NAT gateway vs 1 NAT Gateway per availability zone should not cause traffic disruptions
- Flexible route table association - users can select how they want to associate route tables
- Support for AWS Network Firewall
- Support for AWS Route53 Resolver/DNSSEC (yes, no? - TBD)
- Tags - no idea yet
- Examples not only validate different configurations, but demonstrate different design patterns used for networking
- What does migrating from v3.x to v4.x look like

## Resources

### Supported

- [ ] aws_customer_gateway
- [x] aws_default_network_acl
- [x] aws_default_route_table
- [x] aws_default_security_group
- ❌ aws_default_subnet :stop:
- [x] aws_default_vpc
- [x] aws_default_vpc_dhcp_options
- [ ] aws_ec2_managed_prefix_list
- [ ] aws_ec2_managed_prefix_list_entry
- [ ] aws_egress_only_internet_gateway
- [ ] aws_flow_log
- [ ] aws_internet_gateway
- [ ] aws_main_route_table_association
- [ ] aws_nat_gateway
- [ ] aws_network_acl
- [ ] aws_network_acl_rule
- [ ] aws_network_interface
- [ ] aws_network_interface_attachment
- [ ] aws_network_interface_sg_attachment
- [ ] aws_route
- [ ] aws_route_table
- [ ] aws_route_table_association
- ❌ aws_security_group
- ❌ aws_security_group_rule
- [ ] aws_subnet
- [x] aws_vpc
- [x] aws_vpc_dhcp_options
- [x] aws_vpc_dhcp_options_association
- [x] aws_vpc_endpoint
- [ ] aws_vpc_endpoint_connection_notification
- [ ] aws_vpc_endpoint_route_table_association
- [ ] aws_vpc_endpoint_service
- [ ] aws_vpc_endpoint_service_allowed_principal
- [ ] aws_vpc_endpoint_subnet_association
- [x] aws_vpc_ipv4_cidr_block_association
- [ ] aws_vpc_peering_connection
- [ ] aws_vpc_peering_connection_accepter
- [ ] aws_vpc_peering_connection_options
- [ ] aws_route53_resolver_dnssec_config

### Not Supported

- [ ] aws_vpn_connection
- [ ] aws_vpn_connection_route
- [ ] aws_vpn_gateway
- [ ] aws_vpn_gateway_attachment
- [ ] aws_vpn_gateway_route_propagation

## Usage

See [`examples`](./examples) directory for working examples to reference:

```hcl
module "vpc" {
  source = "clowdhaus/vpc-v4/aws"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Examples

Examples codified under the [`examples`](./examples) are intended to give users references for how to use the module(s) as well as testing/validating changes to the source code of the module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow maintainers to test your changes and to keep the examples up to date for users. Thank you!

- [Complete](./examples/complete)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.62 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.62 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_default_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl) | resource |
| [aws_default_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_default_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc) | resource |
| [aws_default_vpc_dhcp_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc_dhcp_options) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpc_ipv4_cidr_block_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipv4_cidr_block_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#input\_assign\_generated\_ipv6\_cidr\_block) | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is `false` | `bool` | `null` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `"0.0.0.0/0"` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if VPC should be created (it affects almost all resources) | `bool` | `true` | no |
| <a name="input_create_dhcp_options"></a> [create\_dhcp\_options](#input\_create\_dhcp\_options) | Controls if custom DHCP options set is created | `bool` | `false` | no |
| <a name="input_default_dhcp_options_name"></a> [default\_dhcp\_options\_name](#input\_default\_dhcp\_options\_name) | Name to be used on the default DHCP options | `string` | `""` | no |
| <a name="input_default_dhcp_options_netbios_name_servers"></a> [default\_dhcp\_options\_netbios\_name\_servers](#input\_default\_dhcp\_options\_netbios\_name\_servers) | List of NETBIOS name servers | `list(string)` | `null` | no |
| <a name="input_default_dhcp_options_netbios_node_type"></a> [default\_dhcp\_options\_netbios\_node\_type](#input\_default\_dhcp\_options\_netbios\_node\_type) | The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network | `number` | `null` | no |
| <a name="input_default_dhcp_options_owner_id"></a> [default\_dhcp\_options\_owner\_id](#input\_default\_dhcp\_options\_owner\_id) | The ID of the AWS account that owns the DHCP options set | `string` | `null` | no |
| <a name="input_default_dhcp_options_tags"></a> [default\_dhcp\_options\_tags](#input\_default\_dhcp\_options\_tags) | Additional tags for the default DHCP options | `map(string)` | `{}` | no |
| <a name="input_default_network_acl_egress"></a> [default\_network\_acl\_egress](#input\_default\_network\_acl\_egress) | List of maps for egress rules to set on the default network ACL | `list(map(string))` | `[]` | no |
| <a name="input_default_network_acl_ingress"></a> [default\_network\_acl\_ingress](#input\_default\_network\_acl\_ingress) | List of maps for ingress rules to set on the default network ACL | `list(map(string))` | `[]` | no |
| <a name="input_default_network_acl_name"></a> [default\_network\_acl\_name](#input\_default\_network\_acl\_name) | Name to be used on the default network ACL | `string` | `""` | no |
| <a name="input_default_network_acl_tags"></a> [default\_network\_acl\_tags](#input\_default\_network\_acl\_tags) | Additional tags for the default network ACL | `map(string)` | `{}` | no |
| <a name="input_default_route_table_name"></a> [default\_route\_table\_name](#input\_default\_route\_table\_name) | Name to be used on the default route table | `string` | `""` | no |
| <a name="input_default_route_table_propagating_vgws"></a> [default\_route\_table\_propagating\_vgws](#input\_default\_route\_table\_propagating\_vgws) | List of virtual gateways for propagation | `list(string)` | `[]` | no |
| <a name="input_default_route_table_routes"></a> [default\_route\_table\_routes](#input\_default\_route\_table\_routes) | Configuration block of routes. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table#route | `list(map(string))` | `[]` | no |
| <a name="input_default_route_table_tags"></a> [default\_route\_table\_tags](#input\_default\_route\_table\_tags) | Additional tags for the default route table | `map(string)` | `{}` | no |
| <a name="input_default_route_table_timeouts"></a> [default\_route\_table\_timeouts](#input\_default\_route\_table\_timeouts) | Create and update timeout configurations for the default route table | `map(string)` | `{}` | no |
| <a name="input_default_security_group_egress"></a> [default\_security\_group\_egress](#input\_default\_security\_group\_egress) | List of maps of egress rules to set on the default security group | `list(map(string))` | `[]` | no |
| <a name="input_default_security_group_ingress"></a> [default\_security\_group\_ingress](#input\_default\_security\_group\_ingress) | List of maps of ingress rules to set on the default security group | `list(map(string))` | `[]` | no |
| <a name="input_default_security_group_name"></a> [default\_security\_group\_name](#input\_default\_security\_group\_name) | Name to be used on the default security group | `string` | `""` | no |
| <a name="input_default_security_group_tags"></a> [default\_security\_group\_tags](#input\_default\_security\_group\_tags) | Additional tags for the default security group | `map(string)` | `{}` | no |
| <a name="input_default_vpc_enable_classiclink"></a> [default\_vpc\_enable\_classiclink](#input\_default\_vpc\_enable\_classiclink) | A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic | `bool` | `null` | no |
| <a name="input_default_vpc_enable_dns_hostnames"></a> [default\_vpc\_enable\_dns\_hostnames](#input\_default\_vpc\_enable\_dns\_hostnames) | A boolean flag to enable/disable DNS hostnames in the VPC. Defaults `false` | `bool` | `null` | no |
| <a name="input_default_vpc_enable_dns_support"></a> [default\_vpc\_enable\_dns\_support](#input\_default\_vpc\_enable\_dns\_support) | A boolean flag to enable/disable DNS support in the VPC. Defaults `true` | `bool` | `null` | no |
| <a name="input_default_vpc_name"></a> [default\_vpc\_name](#input\_default\_vpc\_name) | Name to be used on the Default VPC | `string` | `""` | no |
| <a name="input_default_vpc_tags"></a> [default\_vpc\_tags](#input\_default\_vpc\_tags) | Additional tags for the Default VPC | `map(string)` | `{}` | no |
| <a name="input_dhcp_options_domain_name"></a> [dhcp\_options\_domain\_name](#input\_dhcp\_options\_domain\_name) | The suffix domain name to use by default when resolving non fully qualified domain names | `string` | `null` | no |
| <a name="input_dhcp_options_domain_name_servers"></a> [dhcp\_options\_domain\_name\_servers](#input\_dhcp\_options\_domain\_name\_servers) | List of name servers to configure in `/etc/resolv.conf` | `list(string)` | <pre>[<br>  "AmazonProvidedDNS"<br>]</pre> | no |
| <a name="input_dhcp_options_netbios_name_servers"></a> [dhcp\_options\_netbios\_name\_servers](#input\_dhcp\_options\_netbios\_name\_servers) | List of NETBIOS name servers | `list(string)` | `null` | no |
| <a name="input_dhcp_options_netbios_node_type"></a> [dhcp\_options\_netbios\_node\_type](#input\_dhcp\_options\_netbios\_node\_type) | The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network | `number` | `null` | no |
| <a name="input_dhcp_options_ntp_servers"></a> [dhcp\_options\_ntp\_servers](#input\_dhcp\_options\_ntp\_servers) | List of NTP servers to configure | `list(string)` | `null` | no |
| <a name="input_dhcp_options_tags"></a> [dhcp\_options\_tags](#input\_dhcp\_options\_tags) | Additional tags for the DHCP option set | `map(string)` | `{}` | no |
| <a name="input_enable_classiclink"></a> [enable\_classiclink](#input\_enable\_classiclink) | A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic | `bool` | `null` | no |
| <a name="input_enable_classiclink_dns_support"></a> [enable\_classiclink\_dns\_support](#input\_enable\_classiclink\_dns\_support) | A boolean flag to enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic | `bool` | `null` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | A boolean flag to enable/disable DNS hostnames in the VPC. Defaults `false` | `bool` | `null` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | A boolean flag to enable/disable DNS support in the VPC. Defaults `true` | `bool` | `null` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC. Default is `default`, which makes your instances shared on the host | `string` | `"default"` | no |
| <a name="input_manage_default_dhcp_options"></a> [manage\_default\_dhcp\_options](#input\_manage\_default\_dhcp\_options) | Determines whether the default DHCP options are adopted and managed by the module | `bool` | `false` | no |
| <a name="input_manage_default_network_acl"></a> [manage\_default\_network\_acl](#input\_manage\_default\_network\_acl) | Determines whether the default network ACL is adopted and managed by the module | `bool` | `false` | no |
| <a name="input_manage_default_route_table"></a> [manage\_default\_route\_table](#input\_manage\_default\_route\_table) | Determines whether the default route table is adopted and managed by the module | `bool` | `false` | no |
| <a name="input_manage_default_security_group"></a> [manage\_default\_security\_group](#input\_manage\_default\_security\_group) | Determines whether the default security group is adopted and managed by the module | `bool` | `true` | no |
| <a name="input_manage_default_vpc"></a> [manage\_default\_vpc](#input\_manage\_default\_vpc) | Determines whether the default VPC is adopted and managed by the module | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_secondary_cidr_blocks"></a> [secondary\_cidr\_blocks](#input\_secondary\_cidr\_blocks) | List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Additional tags for the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of VPC |
| <a name="output_cidr_block"></a> [cidr\_block](#output\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_default_dhcp_options_arn"></a> [default\_dhcp\_options\_arn](#output\_default\_dhcp\_options\_arn) | The ARN of the default DHCP options set |
| <a name="output_default_dhcp_options_id"></a> [default\_dhcp\_options\_id](#output\_default\_dhcp\_options\_id) | The ID of the default DHCP options set |
| <a name="output_default_network_acl_arn"></a> [default\_network\_acl\_arn](#output\_default\_network\_acl\_arn) | ARN of the Default Network ACL |
| <a name="output_default_network_acl_id"></a> [default\_network\_acl\_id](#output\_default\_network\_acl\_id) | The ID of the network ACL created by default on VPC creation |
| <a name="output_default_route_table_arn"></a> [default\_route\_table\_arn](#output\_default\_route\_table\_arn) | ARN of the default route table |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | The ID of the route table created by default on VPC creation |
| <a name="output_default_security_group_arn"></a> [default\_security\_group\_arn](#output\_default\_security\_group\_arn) | The ARN of the security group created by default on VPC creation |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_default_vpc_arn"></a> [default\_vpc\_arn](#output\_default\_vpc\_arn) | The ARN of the Default VPC |
| <a name="output_default_vpc_cidr_block"></a> [default\_vpc\_cidr\_block](#output\_default\_vpc\_cidr\_block) | The CIDR block of the Default VPC |
| <a name="output_default_vpc_default_network_acl_id"></a> [default\_vpc\_default\_network\_acl\_id](#output\_default\_vpc\_default\_network\_acl\_id) | The ID of the default network ACL of the Default VPC |
| <a name="output_default_vpc_default_route_table_id"></a> [default\_vpc\_default\_route\_table\_id](#output\_default\_vpc\_default\_route\_table\_id) | The ID of the default route table of the Default VPC |
| <a name="output_default_vpc_default_security_group_id"></a> [default\_vpc\_default\_security\_group\_id](#output\_default\_vpc\_default\_security\_group\_id) | The ID of the security group created by default on Default VPC creation |
| <a name="output_default_vpc_enable_dns_hostnames"></a> [default\_vpc\_enable\_dns\_hostnames](#output\_default\_vpc\_enable\_dns\_hostnames) | Whether or not the Default VPC has DNS hostname support |
| <a name="output_default_vpc_enable_dns_support"></a> [default\_vpc\_enable\_dns\_support](#output\_default\_vpc\_enable\_dns\_support) | Whether or not the Default VPC has DNS support |
| <a name="output_default_vpc_id"></a> [default\_vpc\_id](#output\_default\_vpc\_id) | The ID of the Default VPC |
| <a name="output_default_vpc_instance_tenancy"></a> [default\_vpc\_instance\_tenancy](#output\_default\_vpc\_instance\_tenancy) | Tenancy of instances spin up within Default VPC |
| <a name="output_default_vpc_main_route_table_id"></a> [default\_vpc\_main\_route\_table\_id](#output\_default\_vpc\_main\_route\_table\_id) | The ID of the main route table associated with the Default VPC |
| <a name="output_dhcp_options_arn"></a> [dhcp\_options\_arn](#output\_dhcp\_options\_arn) | The ARN of the DHCP options set |
| <a name="output_dhcp_options_id"></a> [dhcp\_options\_id](#output\_dhcp\_options\_id) | The ID of the DHCP options set |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC |
| <a name="output_ipv6_association_id"></a> [ipv6\_association\_id](#output\_ipv6\_association\_id) | The association ID for the IPv6 CIDR block |
| <a name="output_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#output\_ipv6\_cidr\_block) | The IPv6 CIDR block |
| <a name="output_main_route_table_id"></a> [main\_route\_table\_id](#output\_main\_route\_table\_id) | The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an `aws_main_route_table_association` |
| <a name="output_secondary_ipv4_cidr_block_assocations"></a> [secondary\_ipv4\_cidr\_block\_assocations](#output\_secondary\_ipv4\_cidr\_block\_assocations) | The IPv6 CIDR block |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](LICENSE).
