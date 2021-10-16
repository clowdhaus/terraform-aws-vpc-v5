# AWS VPC Terraform module

:warning: This is experimental only - please do not rely on this being stable at this time. The goal of this project is to explore changes to the upstream `terraform-aws-vpc` module and hopefully/eventually land those changes there as v4.0. For now, this is just for testing and open collaboration on what that next version might look like, and how users can migrate from v3.x to v4.x

## Desgin Goals

- Terraform v1.x is min supported now that its GA
- Use of maps/`for_each` over `count` for stable/isolated changes
- n-number of subnet groups with custom naming scheme
  - Currently only `private`, `public`, `internal`, `database`, and `redshift` are permitted and using those names
- Ability to stack CIDR ranges - AWS allows up to 5 CIDR ranges to be stacked on a VPC
- Changing between 1 NAT gateway vs 1 NAT Gateway per availability zone should not cause traffic disruptions
- Flexible route table association - users can select how they want to associate route tables
- Support for AWS Network Firewall
- Support for AWS Route53 Resolver/DNSSEC (yes, no? - TBD)
- Tags - no idea yet
- Examples not only validate different configurations, but demonstrate different design patterns used for networking
- What does migrating from v3.x to v4.x look like

## Usage

See [`examples`](./examples) directory for working examples to reference:

```hcl
module "vpc" {
  source = "clowdhaus/vpc-v4/aws"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Examples

Examples codified under the [`examples`](./examples) are intended to give users references for how to use the module(s) as well as testing/validating changes to the source code of the module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow maintainers to test your changes and to keep the examples up to date for users. Thank you!

- [Complete](./examples/complete)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.62 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](LICENSE).
