# AWS Subnets Terraform Module

Terraform module which creates AWS VPC Subnet resources.

This module is designed to create a set of one or more subnets that serve a desired purpose. For example, one module definition would be used for public subnets, another for private subnets, another for database subnets, etc. This design affords users the ability to create any desired design configuration for a set of subnets, where multiple sets of subnets are composed under the respective VPC to create the desired network topology.

## Usage

See [`examples`](https://github.com/clowdhaus/terraform-aws-vpc-v5/tree/main/examples) directory for working examples to reference:

### Public Subnets

```hcl
module "public_subnets" {
  source = "terraform-aws-modules/vpc/aws//modules/subnet"

  name   = "example-public"
  vpc_id = "vpc-12345678"

  subnets = {
    "us-east-1a" = {
      cidr_block         = "10.98.1.0/24"
      availability_zone  = "us-east-1a"
      create_nat_gateway = true
    }
    "us-east-1b" = {
      cidr_block         = "10.98.2.0/24"
      availability_zone  = "us-east-1b"
      create_nat_gateway = true
    }
    "us-east-1c" = {
      cidr_block         = "10.98.3.0/24"
      availability_zone  = "us-east-1a"
      create_nat_gateway = true
    }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["us-east-1a", "us-east-1a", "us-east-1c"]
      routes = {
        igw = {
          destination_cidr_block = "0.0.0.0/0"
          gateway_id             = "igw-1ff7a07b"
        }
      }
    }
  }

  ingress_network_acl_rules = {
    100 = {
      protocol    = "-1"
      rule_action = "Allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
    }
  }

  egress_network_acl_rules = {
    100 = {
      protocol    = "-1"
      rule_action = "Allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
    }
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
```
### Private Subnets

```hcl
module "private_subnets" {
  source = "terraform-aws-modules/vpc/aws//modules/subnet"

  name   = "example-private"
  vpc_id = "vpc-12345678"

  # TODO

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_subnet_cidr_reservation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_subnet_cidr_reservation) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_ram_resource_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_ipv6_address_on_creation"></a> [assign\_ipv6\_address\_on\_creation](#input\_assign\_ipv6\_address\_on\_creation) | Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address | `bool` | `null` | no |
| <a name="input_associated_gateways"></a> [associated\_gateways](#input\_associated\_gateways) | Map of gateways to associate with the route table | `map(string)` | `{}` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | AZ for the subnet | `string` | `null` | no |
| <a name="input_availability_zone_id"></a> [availability\_zone\_id](#input\_availability\_zone\_id) | AZ ID of the subnet. This argument is not supported in all regions or partitions. If necessary, use `availability_zone` instead | `string` | `null` | no |
| <a name="input_cidr_reservations"></a> [cidr\_reservations](#input\_cidr\_reservations) | Map of CIDR reservations to create | `any` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created | `bool` | `true` | no |
| <a name="input_create_eip"></a> [create\_eip](#input\_create\_eip) | Controls if an EIP should be created for the NAT gateway | `bool` | `true` | no |
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | Controls if a NAT gateway should be created | `bool` | `true` | no |
| <a name="input_create_route_table"></a> [create\_route\_table](#input\_create\_route\_table) | Controls if a route table should be created | `bool` | `true` | no |
| <a name="input_customer_owned_ipv4_pool"></a> [customer\_owned\_ipv4\_pool](#input\_customer\_owned\_ipv4\_pool) | The customer owned IPv4 address pool. Typically used with the `map_customer_owned_ip_on_launch` argument. The `outpost_arn` argument must be specified when configured | `string` | `null` | no |
| <a name="input_eip_address"></a> [eip\_address](#input\_eip\_address) | IP address from an EC2 BYOIP pool | `string` | `null` | no |
| <a name="input_eip_associate_with_private_ip"></a> [eip\_associate\_with\_private\_ip](#input\_eip\_associate\_with\_private\_ip) | User-specified primary or secondary private IP address to associate with the Elastic IP address. If no private IP address is specified, the Elastic IP address is associated with the primary private IP address | `bool` | `null` | no |
| <a name="input_eip_customer_owned_ipv4_pool"></a> [eip\_customer\_owned\_ipv4\_pool](#input\_eip\_customer\_owned\_ipv4\_pool) | ID of a customer-owned address pool | `string` | `null` | no |
| <a name="input_eip_network_border_group"></a> [eip\_network\_border\_group](#input\_eip\_network\_border\_group) | Location from which the IP address is advertised. Use this parameter to limit the address to this location | `string` | `null` | no |
| <a name="input_eip_public_ipv4_pool"></a> [eip\_public\_ipv4\_pool](#input\_eip\_public\_ipv4\_pool) | EC2 IPv4 address pool identifier or `amazon` | `string` | `null` | no |
| <a name="input_enable_dns64"></a> [enable\_dns64](#input\_enable\_dns64) | Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations | `bool` | `null` | no |
| <a name="input_enable_resource_name_dns_a_record_on_launch"></a> [enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS A records | `bool` | `null` | no |
| <a name="input_enable_resource_name_dns_aaaa_record_on_launch"></a> [enable\_resource\_name\_dns\_aaaa\_record\_on\_launch](#input\_enable\_resource\_name\_dns\_aaaa\_record\_on\_launch) | Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records | `bool` | `null` | no |
| <a name="input_ipv4_cidr_block"></a> [ipv4\_cidr\_block](#input\_ipv4\_cidr\_block) | The IPv4 CIDR block for the subnet | `string` | `null` | no |
| <a name="input_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#input\_ipv6\_cidr\_block) | The IPv6 network range for the subnet, in CIDR notation. The subnet size must use a /64 prefix length | `string` | `null` | no |
| <a name="input_ipv6_native"></a> [ipv6\_native](#input\_ipv6\_native) | Indicates whether to create an IPv6-only subnet | `bool` | `null` | no |
| <a name="input_map_customer_owned_ip_on_launch"></a> [map\_customer\_owned\_ip\_on\_launch](#input\_map\_customer\_owned\_ip\_on\_launch) | Specify true to indicate that network interfaces created in the subnet should be assigned a customer owned IP address. The `customer_owned_ipv4_pool` and `outpost_arn` arguments must be specified when set to `true` | `bool` | `null` | no |
| <a name="input_map_public_ip_on_launch"></a> [map\_public\_ip\_on\_launch](#input\_map\_public\_ip\_on\_launch) | Specify true to indicate that instances launched into the subnet should be assigned a public IP address | `bool` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name used across the resources created | `string` | `""` | no |
| <a name="input_nat_gateway_allocation_id"></a> [nat\_gateway\_allocation\_id](#input\_nat\_gateway\_allocation\_id) | The Allocation ID of the Elastic IP address for the gateway. Required when `nat_gateway_connectivity_type` is `public` and `create_eip` is `false` | `string` | `null` | no |
| <a name="input_nat_gateway_connectivity_type"></a> [nat\_gateway\_connectivity\_type](#input\_nat\_gateway\_connectivity\_type) | Connectivity type for the gateway. Valid values are `private` and `public`. Defaults to `public` | `string` | `null` | no |
| <a name="input_outpost_arn"></a> [outpost\_arn](#input\_outpost\_arn) | The Amazon Resource Name (ARN) of the Outpost | `string` | `null` | no |
| <a name="input_private_dns_hostname_type_on_launch"></a> [private\_dns\_hostname\_type\_on\_launch](#input\_private\_dns\_hostname\_type\_on\_launch) | The type of hostnames to assign to instances in the subnet at launch. For IPv6-only subnets, an instance DNS name must be based on the instance ID. For dual-stack and IPv4-only subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID | `string` | `null` | no |
| <a name="input_resource_share_arn"></a> [resource\_share\_arn](#input\_resource\_share\_arn) | Amazon Resource Name (ARN) of the RAM Resource Share | `string` | `null` | no |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | The ID of an exissting route table to associate with the subnet | `string` | `null` | no |
| <a name="input_route_table_tags"></a> [route\_table\_tags](#input\_route\_table\_tags) | Additional tags for the VPC | `map(string)` | `{}` | no |
| <a name="input_route_table_timeouts"></a> [route\_table\_timeouts](#input\_route\_table\_timeouts) | Create, update, and delete timeout configurations for route table | `map(string)` | `{}` | no |
| <a name="input_route_timeouts"></a> [route\_timeouts](#input\_route\_timeouts) | Default create, update, and delete timeout configurations for routes | `map(string)` | `{}` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | Map of route definitions to create | `map(any)` | `{}` | no |
| <a name="input_share_subnet"></a> [share\_subnet](#input\_share\_subnet) | Controls if the subnet should be shared via RAM resource association | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Create and delete timeout configurations for subnet | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC the resources are created within | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the subnet |
| <a name="output_ec2_subnet_cidr_reservations"></a> [ec2\_subnet\_cidr\_reservations](#output\_ec2\_subnet\_cidr\_reservations) | Map of EC2 subnet CIDR reservations created and their attributes |
| <a name="output_eip_allocation_id"></a> [eip\_allocation\_id](#output\_eip\_allocation\_id) | ID that AWS assigns to represent the allocation of the Elastic IP address for use with instances in a VPC |
| <a name="output_eip_association_id"></a> [eip\_association\_id](#output\_eip\_association\_id) | ID representing the association of the address with an instance in a VPC |
| <a name="output_eip_carrier_ip"></a> [eip\_carrier\_ip](#output\_eip\_carrier\_ip) | Carrier IP address |
| <a name="output_eip_customer_owned_ip"></a> [eip\_customer\_owned\_ip](#output\_eip\_customer\_owned\_ip) | Customer owned IP |
| <a name="output_eip_id"></a> [eip\_id](#output\_eip\_id) | Contains the EIP allocation ID |
| <a name="output_eip_private_dns"></a> [eip\_private\_dns](#output\_eip\_private\_dns) | The Private DNS associated with the Elastic IP address |
| <a name="output_eip_private_ip"></a> [eip\_private\_ip](#output\_eip\_private\_ip) | Contains the private IP address |
| <a name="output_eip_public_dns"></a> [eip\_public\_dns](#output\_eip\_public\_dns) | Public DNS associated with the Elastic IP address |
| <a name="output_eip_public_ip"></a> [eip\_public\_ip](#output\_eip\_public\_ip) | Contains the public IP address |
| <a name="output_id"></a> [id](#output\_id) | The ID of the subnet |
| <a name="output_ipv4_cidr_block"></a> [ipv4\_cidr\_block](#output\_ipv4\_cidr\_block) | IPv4 CIDR block assigned to the subnet |
| <a name="output_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#output\_ipv6\_cidr\_block) | IPv6 CIDR block assigned to the subnet |
| <a name="output_ipv6_cidr_block_association_id"></a> [ipv6\_cidr\_block\_association\_id](#output\_ipv6\_cidr\_block\_association\_id) | The association ID for the IPv6 CIDR block |
| <a name="output_nat_gateway_allocation_id"></a> [nat\_gateway\_allocation\_id](#output\_nat\_gateway\_allocation\_id) | The Allocation ID of the Elastic IP address for the gateway |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | The ID of the NAT Gateway |
| <a name="output_nat_gateway_network_interface_id"></a> [nat\_gateway\_network\_interface\_id](#output\_nat\_gateway\_network\_interface\_id) | The ID of the network interface associated with the NAT gateway |
| <a name="output_nat_gateway_private_ip"></a> [nat\_gateway\_private\_ip](#output\_nat\_gateway\_private\_ip) | The private IP address of the NAT Gateway |
| <a name="output_nat_gateway_public_ip"></a> [nat\_gateway\_public\_ip](#output\_nat\_gateway\_public\_ip) | The public IP address of the NAT Gateway |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | The ID of the AWS account that owns the subnet |
| <a name="output_ram_resource_association_id"></a> [ram\_resource\_association\_id](#output\_ram\_resource\_association\_id) | The Amazon Resource Name (ARN) of the resource share |
| <a name="output_route_table_arn"></a> [route\_table\_arn](#output\_route\_table\_arn) | The ARN of the route table |
| <a name="output_route_table_gateway_association_ids"></a> [route\_table\_gateway\_association\_ids](#output\_route\_table\_gateway\_association\_ids) | List of subnet route table association IDs |
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | The ID of the route table |
| <a name="output_route_table_owner_id"></a> [route\_table\_owner\_id](#output\_route\_table\_owner\_id) | The ID of the AWS account that owns the route table |
| <a name="output_route_table_subnet_association_id"></a> [route\_table\_subnet\_association\_id](#output\_route\_table\_subnet\_association\_id) | The ID of the route table subnet association |
| <a name="output_routes"></a> [routes](#output\_routes) | Map of routes created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-vpc-v5/blob/main/LICENSE).
