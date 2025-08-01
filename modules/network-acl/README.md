# AWS Network ACL Terraform Module

Terraform module which creates AWS Network ACL resources.

## Usage

See [`examples`](https://github.com/clowdhaus/terraform-aws-vpc-v5/tree/main/examples) directory for working examples to reference:

```hcl
module "network_acl" {
  source = "terraform-aws-modules/vpc/aws//modules/network-acl"

  # TODO

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
| [aws_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Controls if network ACL resources should be created | `bool` | `true` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | Network ACL egresss rules to be added to the Network ACL | `map(any)` | `{}` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | Network ACL ingress rules to be added to the Network ACL | `map(any)` | `{}` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The IDs of the subnets to associate with the Network ACL created | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to create the resources in | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ID of the network ACL |
| <a name="output_id"></a> [id](#output\_id) | The ARN of the network ACL |
| <a name="output_rules_egress"></a> [rules\_egress](#output\_rules\_egress) | Map of egress network ACL rules created and their attributes |
| <a name="output_rules_ingress"></a> [rules\_ingress](#output\_rules\_ingress) | Map of ingress network ACL rules created and their attributes |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-vpc-v5/blob/main/LICENSE).
