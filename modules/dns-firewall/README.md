# AWS DNS (Route53 Resolver) Firewall Terraform Module

Terraform module which creates AWS Route53 Resolver Firewall resources.

## Usage

See [`examples`](https://github.com/clowdhaus/terraform-aws-vpc-v4/tree/main/examples) directory for working examples to reference:

```hcl
module "dns_firewall" {
  source = "terraform-aws-modules/vpc/aws//modules/dns-firewall"

  name   = "Example"
  vpc_id = "vpc-12345678"

  rules = {
    block = {
      name           = "blockit"
      priority       = 110
      action         = "BLOCK"
      block_response = "NODATA"
      domains        = ["google.com."]

      tags = { rule = true }
    }
    block_override = {
      priority                = 120
      action                  = "BLOCK"
      block_response          = "OVERRIDE"
      block_override_dns_type = "CNAME"
      block_override_domain   = "example.com"
      block_override_ttl      = 1
      domains                 = ["microsoft.com."]
    }
    # Unfortunately, a data source does not exist yet to pull managed domain lists
    # but users can stil copy the managed domain list ID and paste it into the config
    # block_managed_domain_list = {
    #   priority       = 135
    #   action         = "BLOCK"
    #   block_response = "NODATA"
    #   domain_list_id =  data.aws_route53_resolver_firewall_domain_list.this.id # => "rslvr-fdl-fad18de921a64bfa"
    # }
    allow = {
      priority = 130
      action   = "ALLOW"
      domains  = ["amazon.com.", "amazonaws.com."]
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
| [aws_route53_resolver_firewall_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_config) | resource |
| [aws_route53_resolver_firewall_domain_list.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_domain_list) | resource |
| [aws_route53_resolver_firewall_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_rule) | resource |
| [aws_route53_resolver_firewall_rule_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_rule_group) | resource |
| [aws_route53_resolver_firewall_rule_group_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_rule_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created; affects all resources | `bool` | `true` | no |
| <a name="input_firewall_fail_open"></a> [firewall\_fail\_open](#input\_firewall\_fail\_open) | Determines how Route 53 Resolver handles queries during failures. Valid values: `ENABLED`, `DISABLED`. Defaults is `ENABLED` | `string` | `"ENABLED"` | no |
| <a name="input_mutation_protection"></a> [mutation\_protection](#input\_mutation\_protection) | If enabled, this setting disallows modification or removal of the association, to help prevent against accidentally altering DNS firewall protections. Valid values: `ENABLED`, `DISABLED` | `string` | `"ENABLED"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of used across the resources created | `string` | `""` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | The setting that determines the processing order of the rule group among the rule groups that you associate with the specified VPC. DNS Firewall filters VPC traffic starting from the rule group with the lowest numeric priority setting. Must between `100` and `9900` | `number` | `101` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | A map of rule definitions to create | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC that the configuration is for | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_id"></a> [config\_id](#output\_config\_id) | The ID of the firewall configuration |
| <a name="output_domain_lists"></a> [domain\_lists](#output\_domain\_lists) | Map of all domain lists created and their attributes |
| <a name="output_rule_group_arn"></a> [rule\_group\_arn](#output\_rule\_group\_arn) | The ARN (Amazon Resource Name) of the rule group |
| <a name="output_rule_group_association_arn"></a> [rule\_group\_association\_arn](#output\_rule\_group\_association\_arn) | The ARN (Amazon Resource Name) of the rule group association |
| <a name="output_rule_group_association_id"></a> [rule\_group\_association\_id](#output\_rule\_group\_association\_id) | The ID of the rule group association |
| <a name="output_rule_group_id"></a> [rule\_group\_id](#output\_rule\_group\_id) | The ID of the rule group |
| <a name="output_rule_group_share_status"></a> [rule\_group\_share\_status](#output\_rule\_group\_share\_status) | Whether the rule group is shared with other AWS accounts, or was shared with the current account by another AWS account. Sharing is configured through AWS Resource Access Manager (AWS RAM). Valid values: `NOT_SHARED`, `SHARED_BY_ME`, `SHARED_WITH_ME` |
| <a name="output_rules"></a> [rules](#output\_rules) | Map of all rules created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-vpc-v4/blob/main/LICENSE).
