# v3.x to v4.x Changes

## Variables

### Renamed

- `cidr` -> `cidr_block` to match Terraform AWS provider
- `enable_ipv6` -> `assign_generated_ipv6_cidr_block` to match Terraform AWS provider

### Modified

- `secondary_cidr_blocks` was changed from a `count`/list in the `aws_vpc_ipv4_cidr_block_association` resource to a `for_each`/toset(list)
- `manage_default_security_group` default value changed from `false` to `true`
