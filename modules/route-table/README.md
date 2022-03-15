# AWS Route Table Terraform Module

Terraform module which creates AWS Route Table resources.

## Usage

See [`examples`](https://github.com/clowdhaus/terraform-aws-vpc-v4/tree/main/examples) directory for working examples to reference:

```hcl
module "route_table" {
  source = "terraform-aws-modules/vpc/aws//modules/route_table"

  name   = "example-public"
  vpc_id = "vpc-12345678"

  routes = {
    ipv4_igw = {
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = "igw-1ff7a07b"
    }
    ipv6_igw = {
      destination_cidr_block = "::/0"
      gateway_id             = "igw-1ff7a07b"
    }
  }

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
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associated_gateway_ids"></a> [associated\_gateway\_ids](#input\_associated\_gateway\_ids) | The IDs of the gateways to associate with the route table | `list(string)` | `[]` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Route table name | `string` | `null` | no |
| <a name="input_route_timeouts"></a> [route\_timeouts](#input\_route\_timeouts) | Create, update, and delete timeout configurations for routes | `map(string)` | `{}` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | Map of route definitions to create | `map(any)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Create, update, and delete timeout configurations for route table | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to create the route table within | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the route table |
| <a name="output_gateway_association_ids"></a> [gateway\_association\_ids](#output\_gateway\_association\_ids) | List of route table gateway association IDs |
| <a name="output_id"></a> [id](#output\_id) | The ID of the routing table |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | The ID of the AWS account that owns the route table |
| <a name="output_routes"></a> [routes](#output\_routes) | Map of routes created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-vpc-v4/blob/main/LICENSE).
