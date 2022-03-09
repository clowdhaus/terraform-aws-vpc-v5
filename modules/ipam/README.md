# AWS VPC IPAM Terraform Module

Terraform module which creates AWS VPC IPAM resources.

## Usage

See [`examples`](https://github.com/clowdhaus/terraform-aws-vpc-v4/tree/main/examples) directory for working examples to reference:

```hcl
module "ipam" {
  source = "terraform-aws-modules/vpc/aws//modules/ipam"

  name   = "Example"
  vpc_id = "vpc-12345678"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
```

## Examples

- [Complete](https://github.com/clowdhaus/terraform-aws-vpc-v4/tree/main/examples/complete) VPC example.

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
| [aws_vpc_ipam.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam) | resource |
| [aws_vpc_ipam_pool.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool) | resource |
| [aws_vpc_ipam_scope.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_scope) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created; affects all resources | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the IPAM | `string` | `null` | no |
| <a name="input_operating_regions"></a> [operating\_regions](#input\_operating\_regions) | Determines which locales can be chosen when you create pools. Locale is the Region where you want to make an IPAM pool available for allocations. You can only create pools with locales that match the operating Regions of the IPAM. You can only create VPCs from a pool whose locale matches the VPC's Region | `list(string)` | `[]` | no |
| <a name="input_pools"></a> [pools](#input\_pools) | A map of pool definitions to be created | `any` | `{}` | no |
| <a name="input_scopes"></a> [scopes](#input\_scopes) | A map of scope definitions to be created | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of IPAM |
| <a name="output_id"></a> [id](#output\_id) | The ID of the IPAM |
| <a name="output_private_default_scope_id"></a> [private\_default\_scope\_id](#output\_private\_default\_scope\_id) | The ID of the IPAM's private scope. A scope is a top-level container in IPAM. Each scope represents an IP-independent network. Scopes enable you to represent networks where you have overlapping IP space. The private scope is intended for private IP space |
| <a name="output_public_default_scope_id"></a> [public\_default\_scope\_id](#output\_public\_default\_scope\_id) | The ID of the IPAM's private scope. A scope is a top-level container in IPAM. Each scope represents an IP-independent network. Scopes enable you to represent networks where you have overlapping IP space. The public scope is intended for all internet-routable IP space |
| <a name="output_scope_count"></a> [scope\_count](#output\_scope\_count) | The number of scopes in the IPAM |
| <a name="output_scopes"></a> [scopes](#output\_scopes) | A map of the scopes created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
