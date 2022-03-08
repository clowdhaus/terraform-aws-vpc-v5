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

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created; affects all resources | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of used across the resources created | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
