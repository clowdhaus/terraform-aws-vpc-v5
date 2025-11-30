# AWS VPC IPAM Pool Terraform Module

Terraform module which creates AWS VPC IPAM Pool resources.

## Usage

See [`examples/`](https://github.com/clowdhaus/terraform-aws-vpc-v5/tree/main/examples) directory for working examples to reference:

```hcl
module "ipam_pool" {
  source = "terraform-aws-modules/vpc/aws//modules/ipam-pool"

  name   = "Example"
  vpc_id = "vpc-12345678"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
```

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
| [aws_ram_resource_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_vpc_ipam_pool.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool) | resource |
| [aws_vpc_ipam_pool_cidr.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr) | resource |
| [aws_vpc_ipam_pool_cidr_allocation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr_allocation) | resource |
| [aws_vpc_ipam_preview_next_cidr.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_preview_next_cidr) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_family"></a> [address\_family](#input\_address\_family) | The IP protocol assigned to this pool. You must choose either IPv4 or IPv6 protocol for a pool: Defaults to `ipv4` | `string` | `"ipv4"` | no |
| <a name="input_allocation_default_netmask_length"></a> [allocation\_default\_netmask\_length](#input\_allocation\_default\_netmask\_length) | A default netmask length for allocations added to this pool | `number` | `null` | no |
| <a name="input_allocation_max_netmask_length"></a> [allocation\_max\_netmask\_length](#input\_allocation\_max\_netmask\_length) | The maximum netmask length that will be required for CIDR allocations in this pool | `number` | `null` | no |
| <a name="input_allocation_min_netmask_length"></a> [allocation\_min\_netmask\_length](#input\_allocation\_min\_netmask\_length) | The minimum netmask length that will be required for CIDR allocations in this pool | `number` | `null` | no |
| <a name="input_allocation_resource_tags"></a> [allocation\_resource\_tags](#input\_allocation\_resource\_tags) | Tags that are required for resources that use CIDRs from this IPAM pool. Resources that do not have these tags will not be allowed to allocate space from the pool. If the resources have their tags changed after they have allocated space or if the allocation tagging requirements are changed on the pool, the resource may be marked as noncompliant | `map(string)` | `{}` | no |
| <a name="input_auto_import"></a> [auto\_import](#input\_auto\_import) | If you include this argument, IPAM automatically imports any VPCs you have in your scope that fall within the CIDR range in the pool | `bool` | `null` | no |
| <a name="input_aws_service"></a> [aws\_service](#input\_aws\_service) | Limits which AWS service the pool can be used in. Only useable on public scopes. Valid Values: `ec2` | `string` | `null` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The CIDR you want to assign to the pool | `string` | `null` | no |
| <a name="input_cidr_allocations"></a> [cidr\_allocations](#input\_cidr\_allocations) | A map of CIDR allocation definitions to allocate to the pool | `any` | `{}` | no |
| <a name="input_cidr_authorization_context"></a> [cidr\_authorization\_context](#input\_cidr\_authorization\_context) | A signed document that proves that you are authorized to bring the specified IP address range to Amazon using BYOIP. This is not stored in the state file | `any` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created; affects all resources | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | A description for the IPAM pool | `string` | `null` | no |
| <a name="input_disallowed_cidrs"></a> [disallowed\_cidrs](#input\_disallowed\_cidrs) | Exclude a particular CIDR range from being returned by the pool | `list(string)` | `[]` | no |
| <a name="input_ipam_scope_id"></a> [ipam\_scope\_id](#input\_ipam\_scope\_id) | The ID of the scope in which you would like to create the IPAM pool | `string` | `null` | no |
| <a name="input_locale"></a> [locale](#input\_locale) | The locale in which you would like to create the IPAM pool. Locale is the Region where you want to make an IPAM pool available for allocations. You can only create pools with locales that match the operating Regions of the IPAM | `string` | `null` | no |
| <a name="input_preview_netmask_length"></a> [preview\_netmask\_length](#input\_preview\_netmask\_length) | The netmask length of the CIDR you would like to preview from the IPAM pool | `number` | `null` | no |
| <a name="input_preview_next_cidr"></a> [preview\_next\_cidr](#input\_preview\_next\_cidr) | Controls whether to preview the next available CIDR in the pool | `bool` | `false` | no |
| <a name="input_publicly_advertisable"></a> [publicly\_advertisable](#input\_publicly\_advertisable) | Defines whether or not IPv6 pool space is publicly advertisable over the internet. This option is not available for IPv4 pool space | `bool` | `null` | no |
| <a name="input_ram_resource_associations"></a> [ram\_resource\_associations](#input\_ram\_resource\_associations) | A map of RAM resource associations for the created IPAM pool | `map(string)` | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration | `string` | `null` | no |
| <a name="input_source_ipam_pool_id"></a> [source\_ipam\_pool\_id](#input\_source\_ipam\_pool\_id) | The ID of the source IPAM pool. Use this argument to create a child pool within an existing pool | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the IPAM Pool |
| <a name="output_cidr_allocations"></a> [cidr\_allocations](#output\_cidr\_allocations) | A map of the CIDR allocations provisioned and their attributes |
| <a name="output_cidr_id"></a> [cidr\_id](#output\_cidr\_id) | The ID of the IPAM Pool Cidr concatenated with the IPAM Pool ID |
| <a name="output_id"></a> [id](#output\_id) | ID of the IPAM Pool |
| <a name="output_locale"></a> [locale](#output\_locale) | Locale of the IPAM Pool |
| <a name="output_preview_next_cidr"></a> [preview\_next\_cidr](#output\_preview\_next\_cidr) | The previewed CIDR from the pool |
| <a name="output_preview_next_cidr_id"></a> [preview\_next\_cidr\_id](#output\_preview\_next\_cidr\_id) | The ID of the preview |
| <a name="output_state"></a> [state](#output\_state) | State of the IPAM Pool |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-vpc-v5/blob/main/LICENSE).
