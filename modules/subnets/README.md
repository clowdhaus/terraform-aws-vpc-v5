# AWS Subnets Terraform Module

Terraform module which creates AWS VPC Subnets and their associated resources.

This module is designed to create a set of one or more subnets that serve a desired purpose. For example, one module definition would be used for public subnets, another for private subnets, another for database subnets, etc. This design affords users the ability to create any desired design configuration for a set of subnets, where multiple sets of subnets are composed under the respective VPC to create the desired network topology.

## Usage

See [`examples`](../../examples) directory for working examples to reference:

```hcl
module "public_subnets" {
  source = "terraform-aws-modules/vpc/aws//modules/subnets"

  vpc_id = "vpc-12345678"

  # TODO

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

module "private_subnets" {
  source = "terraform-aws-modules/vpc/aws//modules/subnets"

  vpc_id = "vpc-12345678"

  # TODO

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
```

## Examples

- [Complete](../../examples/complete) VPC example.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_subnet_cidr_reservation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_subnet_cidr_reservation) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Controls if network ACL resources should be created | `bool` | `true` | no |
| <a name="input_create_network_acl"></a> [create\_network\_acl](#input\_create\_network\_acl) | Controls creation of Network ACL resources | `bool` | `true` | no |
| <a name="input_egress_network_acl_rules"></a> [egress\_network\_acl\_rules](#input\_egress\_network\_acl\_rules) | Egress Network ACL rules to be added to the Network ACL | `map(any)` | `{}` | no |
| <a name="input_ingress_network_acl_rules"></a> [ingress\_network\_acl\_rules](#input\_ingress\_network\_acl\_rules) | Ingress Network ACL rules to be added to the Network ACL | `map(any)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Default name to be used as a prefix for the resources created (if a custom name is not provided) | `string` | `""` | no |
| <a name="input_network_acl_tags"></a> [network\_acl\_tags](#input\_network\_acl\_tags) | Additional tags for the Network ACL | `map(string)` | `{}` | no |
| <a name="input_route_table_timeouts"></a> [route\_table\_timeouts](#input\_route\_table\_timeouts) | Create, update, and delete timeout configurations for route table | `map(string)` | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Map of route table definitions | `map(any)` | `{}` | no |
| <a name="input_route_timeouts"></a> [route\_timeouts](#input\_route\_timeouts) | Create, update, and delete timeout configurations for route table routes | `map(string)` | `{}` | no |
| <a name="input_subnet_timeouts"></a> [subnet\_timeouts](#input\_subnet\_timeouts) | Create and delete timeout configurations for subnets | `map(string)` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnet definitions | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to create the resources in | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_subnet_cidr_reservations"></a> [ec2\_subnet\_cidr\_reservations](#output\_ec2\_subnet\_cidr\_reservations) | Map of EC2 subnet CIDR reservations created and their attributes |
| <a name="output_network_acl_arn"></a> [network\_acl\_arn](#output\_network\_acl\_arn) | The ID of the network ACL |
| <a name="output_network_acl_id"></a> [network\_acl\_id](#output\_network\_acl\_id) | The ARN of the network ACL |
| <a name="output_network_acl_rules_egress"></a> [network\_acl\_rules\_egress](#output\_network\_acl\_rules\_egress) | Map of egress network ACL rules created and their attributes |
| <a name="output_network_acl_rules_ingress"></a> [network\_acl\_rules\_ingress](#output\_network\_acl\_rules\_ingress) | Map of ingress network ACL rules created and their attributes |
| <a name="output_route_ids"></a> [route\_ids](#output\_route\_ids) | List of route IDs |
| <a name="output_route_table_gateway_association_ids"></a> [route\_table\_gateway\_association\_ids](#output\_route\_table\_gateway\_association\_ids) | List of gateway route table association IDs |
| <a name="output_route_table_ids"></a> [route\_table\_ids](#output\_route\_table\_ids) | List of route table IDs |
| <a name="output_route_table_subnet_association_ids"></a> [route\_table\_subnet\_association\_ids](#output\_route\_table\_subnet\_association\_ids) | List of subnet route table association IDs |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | Map of route tables created and their attributes |
| <a name="output_routes"></a> [routes](#output\_routes) | Map of routes created and their attributes |
| <a name="output_subnet_arns"></a> [subnet\_arns](#output\_subnet\_arns) | List of subnet ARNs |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | List of subnet IDs |
| <a name="output_subnet_ipv4_cidr_blocks"></a> [subnet\_ipv4\_cidr\_blocks](#output\_subnet\_ipv4\_cidr\_blocks) | List of subnet IPv4 CIDR blocks |
| <a name="output_subnet_ipv6_cidr_blocks"></a> [subnet\_ipv6\_cidr\_blocks](#output\_subnet\_ipv6\_cidr\_blocks) | List of subnet IPv6 CIDR blocks |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Map of subnets created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
