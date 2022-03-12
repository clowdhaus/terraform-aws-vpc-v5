# AWS VPC IPAM Terraform Module

Terraform module which creates AWS VPC IPAM resources.

## Usage

See [`examples/ipam`](https://github.com/clowdhaus/terraform-aws-vpc-v4/tree/main/examples/ipam) for working example to reference:

```hcl
module "ipam" {
  source = "terraform-aws-modules/vpc/aws//modules/ipam"

  description       = "IPAM example"
  operating_regions = ["eu-west-1", "us-west-2"]

  # Top level pool
  pool_cidr                              = "10.0.0.0/8"
  pool_allocation_min_netmask_length     = 10
  pool_allocation_default_netmask_length = 10
  pool_allocation_max_netmask_length     = 16

  # Additional private scopes
  scopes = {
    one = {
      description = "Example scope one"
    }
    two = {
      description = "Example scope two"
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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc_ipam_pool"></a> [vpc\_ipam\_pool](#module\_vpc\_ipam\_pool) | ../ipam-pool | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_ipam.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam) | resource |
| [aws_vpc_ipam_scope.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_scope) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created; affects all resources | `bool` | `true` | no |
| <a name="input_create_ipam_pool"></a> [create\_ipam\_pool](#input\_create\_ipam\_pool) | Controls if IPAM pool should be created | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the IPAM | `string` | `null` | no |
| <a name="input_operating_regions"></a> [operating\_regions](#input\_operating\_regions) | Determines which locales can be chosen when you create pools. Locale is the Region where you want to make an IPAM pool available for allocations. You can only create pools with locales that match the operating Regions of the IPAM. You can only create VPCs from a pool whose locale matches the VPC's Region | `list(string)` | `[]` | no |
| <a name="input_pool_address_family"></a> [pool\_address\_family](#input\_pool\_address\_family) | The IP protocol assigned to this pool. You must choose either IPv4 or IPv6 protocol for a pool: Defaults to `ipv4` | `string` | `"ipv4"` | no |
| <a name="input_pool_allocation_default_netmask_length"></a> [pool\_allocation\_default\_netmask\_length](#input\_pool\_allocation\_default\_netmask\_length) | A default netmask length for allocations added to this pool | `number` | `null` | no |
| <a name="input_pool_allocation_max_netmask_length"></a> [pool\_allocation\_max\_netmask\_length](#input\_pool\_allocation\_max\_netmask\_length) | The maximum netmask length that will be required for CIDR allocations in this pool | `number` | `null` | no |
| <a name="input_pool_allocation_min_netmask_length"></a> [pool\_allocation\_min\_netmask\_length](#input\_pool\_allocation\_min\_netmask\_length) | The minimum netmask length that will be required for CIDR allocations in this pool | `number` | `null` | no |
| <a name="input_pool_allocation_resource_tags"></a> [pool\_allocation\_resource\_tags](#input\_pool\_allocation\_resource\_tags) | Tags that are required for resources that use CIDRs from this IPAM pool. Resources that do not have these tags will not be allowed to allocate space from the pool. If the resources have their tags changed after they have allocated space or if the allocation tagging requirements are changed on the pool, the resource may be marked as noncompliant | `map(string)` | `{}` | no |
| <a name="input_pool_auto_import"></a> [pool\_auto\_import](#input\_pool\_auto\_import) | If you include this argument, IPAM automatically imports any VPCs you have in your scope that fall within the CIDR range in the pool | `bool` | `null` | no |
| <a name="input_pool_aws_service"></a> [pool\_aws\_service](#input\_pool\_aws\_service) | Limits which AWS service the pool can be used in. Only useable on public scopes. Valid Values: `ec2` | `string` | `null` | no |
| <a name="input_pool_cidr"></a> [pool\_cidr](#input\_pool\_cidr) | The CIDR you want to assign to the pool | `string` | `null` | no |
| <a name="input_pool_cidr_allocations"></a> [pool\_cidr\_allocations](#input\_pool\_cidr\_allocations) | A map of CIDR allocation definitions to allocate to the pool | `any` | `{}` | no |
| <a name="input_pool_cidr_authorization_context"></a> [pool\_cidr\_authorization\_context](#input\_pool\_cidr\_authorization\_context) | A signed document that proves that you are authorized to bring the specified IP address range to Amazon using BYOIP. This is not stored in the state file | `any` | `{}` | no |
| <a name="input_pool_description"></a> [pool\_description](#input\_pool\_description) | A description for the IPAM pool | `string` | `null` | no |
| <a name="input_pool_disallowed_cidrs"></a> [pool\_disallowed\_cidrs](#input\_pool\_disallowed\_cidrs) | Exclude a particular CIDR range from being returned by the pool | `list(string)` | `[]` | no |
| <a name="input_pool_locale"></a> [pool\_locale](#input\_pool\_locale) | The locale in which you would like to create the IPAM pool. Locale is the Region where you want to make an IPAM pool available for allocations. You can only create pools with locales that match the operating Regions of the IPAM | `string` | `null` | no |
| <a name="input_pool_preview_netmask_length"></a> [pool\_preview\_netmask\_length](#input\_pool\_preview\_netmask\_length) | The netmask length of the CIDR you would like to preview from the IPAM pool | `number` | `null` | no |
| <a name="input_pool_preview_next_cidr"></a> [pool\_preview\_next\_cidr](#input\_pool\_preview\_next\_cidr) | Controls whether to preview the next available CIDR in the pool | `bool` | `true` | no |
| <a name="input_pool_publicly_advertisable"></a> [pool\_publicly\_advertisable](#input\_pool\_publicly\_advertisable) | Defines whether or not IPv6 pool space is publicly advertisable over the internet. This option is not available for IPv4 pool space | `bool` | `null` | no |
| <a name="input_pool_scope_key"></a> [pool\_scope\_key](#input\_pool\_scope\_key) | The key within the `scopes` map to use for the pool scope | `string` | `null` | no |
| <a name="input_pool_tags"></a> [pool\_tags](#input\_pool\_tags) | A map of additional tags to add to the IPAM pool | `map(string)` | `{}` | no |
| <a name="input_pool_use_private_scope"></a> [pool\_use\_private\_scope](#input\_pool\_use\_private\_scope) | Controls if the pool scope used is private or public. If `false`, the IPAM default public scope is used | `bool` | `true` | no |
| <a name="input_scopes"></a> [scopes](#input\_scopes) | A map of scope definitions to be created | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of IPAM |
| <a name="output_id"></a> [id](#output\_id) | The ID of the IPAM |
| <a name="output_pool_arn"></a> [pool\_arn](#output\_pool\_arn) | ARN of the IPAM Pool |
| <a name="output_pool_cidr_allocations"></a> [pool\_cidr\_allocations](#output\_pool\_cidr\_allocations) | A map of the CIDR allocations provisioned and their attributes |
| <a name="output_pool_cidr_id"></a> [pool\_cidr\_id](#output\_pool\_cidr\_id) | The ID of the IPAM Pool Cidr concatenated with the IPAM Pool ID |
| <a name="output_pool_id"></a> [pool\_id](#output\_pool\_id) | ID of the IPAM Pool |
| <a name="output_pool_preview_next_cidr"></a> [pool\_preview\_next\_cidr](#output\_pool\_preview\_next\_cidr) | The previewed CIDR from the pool |
| <a name="output_pool_preview_next_cidr_id"></a> [pool\_preview\_next\_cidr\_id](#output\_pool\_preview\_next\_cidr\_id) | The ID of the preview |
| <a name="output_pool_state"></a> [pool\_state](#output\_pool\_state) | State of the IPAM Pool |
| <a name="output_private_default_scope_id"></a> [private\_default\_scope\_id](#output\_private\_default\_scope\_id) | The ID of the IPAM's private scope. A scope is a top-level container in IPAM. Each scope represents an IP-independent network. Scopes enable you to represent networks where you have overlapping IP space. The private scope is intended for private IP space |
| <a name="output_public_default_scope_id"></a> [public\_default\_scope\_id](#output\_public\_default\_scope\_id) | The ID of the IPAM's private scope. A scope is a top-level container in IPAM. Each scope represents an IP-independent network. Scopes enable you to represent networks where you have overlapping IP space. The public scope is intended for all internet-routable IP space |
| <a name="output_scope_count"></a> [scope\_count](#output\_scope\_count) | The number of scopes in the IPAM |
| <a name="output_scopes"></a> [scopes](#output\_scopes) | A map of the scopes created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-vpc-v4/blob/main/LICENSE).
