# v3.x to v4.x Changes

## Variables

### Renamed

- `create_vpc` -> `create`
- `cidr` -> `cidr_block` to match Terraform AWS provider
- `enable_ipv6` -> `assign_generated_ipv6_cidr_block` to match Terraform AWS provider

### Modified

- `secondary_cidr_blocks` was changed from a `count`/list in the `aws_vpc_ipv4_cidr_block_association` resource to a `for_each`/toset(list)
- `manage_default_security_group` default value changed from `false` to `true`
- Tags for custom names have been updated to coalesce with `"default-${var.name}"` if a custom name is not provided instead of defaulting to `""`


#### Breaking

- Default network ACLs ingress and egress rules are now cleared when adopted to conform with AWS recommended practices. Users will need to specify ingress/egress rules if they decide to use the default ACL
