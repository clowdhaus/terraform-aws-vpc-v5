# AWS Network ACL Terraform sub-module

Terraform sub-module which creates AWS Network ACL and the associated ACL rules.

## Usage

See [`examples`](../../examples) directory for working examples to reference:

```hcl
module "network_acl" {
  source = "terraform-aws-modules/vpc/aws//modules/network-acl"

  vpc_id = "vpc-12345678"

  # TODO

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
```

## Examples

- [Complete-VPC](../../examples/complete-vpc) with VPC Endpoints.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Controls if network ACL resources should be created | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Default name to be used as a prefix for the resources created (if a custom name is not provided) | `string` | `""` | no |
| <a name="input_network_acl_rules"></a> [network\_acl\_rules](#input\_network\_acl\_rules) | Map of network ACL rules | `map(any)` | `{}` | no |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Map of network ACLs | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the associated VPC | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_acl_rules"></a> [network\_acl\_rules](#output\_network\_acl\_rules) | Map of network ACL rules created and their attributes |
| <a name="output_network_acls"></a> [network\_acls](#output\_network\_acls) | Map of network ACLs created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
