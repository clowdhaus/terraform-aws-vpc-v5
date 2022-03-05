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
| [aws_egress_only_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/egress_only_internet_gateway) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.egress_only_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Controls if network ACL resources should be created | `bool` | `true` | no |
| <a name="input_create_egress_only_igw"></a> [create\_egress\_only\_igw](#input\_create\_egress\_only\_igw) | Controls if an egress only internet gateway set is created | `bool` | `false` | no |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Controls if an internet gateway set is created | `bool` | `false` | no |
| <a name="input_egress_only_igw_routes"></a> [egress\_only\_igw\_routes](#input\_egress\_only\_igw\_routes) | Map of routes for the egress only internet gateway | `map(map(string))` | `{}` | no |
| <a name="input_igw_routes"></a> [igw\_routes](#input\_igw\_routes) | Map of routes for the internet gateway | `map(map(string))` | `{}` | no |
| <a name="input_igw_tags"></a> [igw\_tags](#input\_igw\_tags) | Additional tags for the internet gateway/egress only internet gateway | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Default name to be used as a prefix for the resources created (if a custom name is not provided) | `string` | `""` | no |
| <a name="input_network_acl_rules"></a> [network\_acl\_rules](#input\_network\_acl\_rules) | Map of network ACL rules | `map(any)` | `{}` | no |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Map of network ACLs | `any` | `{}` | no |
| <a name="input_route_table_timeouts"></a> [route\_table\_timeouts](#input\_route\_table\_timeouts) | Create, update, and delete timeout configurations for route tables | `map(string)` | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Map of route table definitions | `map(any)` | `{}` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | Map of route definitions | `map(any)` | `{}` | no |
| <a name="input_subnet_timeouts"></a> [subnet\_timeouts](#input\_subnet\_timeouts) | Create and delete timeout configurations for subnets | `map(string)` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnet definitions | `map(any)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to create the resources in | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_egress_only_igw_id"></a> [egress\_only\_igw\_id](#output\_egress\_only\_igw\_id) | The ID of the egress only internet gateway |
| <a name="output_igw_arn"></a> [igw\_arn](#output\_igw\_arn) | The ARN of the Internet Gateway |
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id) | The ID of the internet gateway |
| <a name="output_network_acl_rules"></a> [network\_acl\_rules](#output\_network\_acl\_rules) | Map of network ACL rules created and their attributes |
| <a name="output_network_acls"></a> [network\_acls](#output\_network\_acls) | Map of network ACLs created and their attributes |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | Map of route tables created and their attributes |
| <a name="output_routes"></a> [routes](#output\_routes) | Map of routes created and their attributes |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Map of subnets created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
