# v3.x to v4.x Changes

## Variables

### Renamed

- `create_vpc` -> `create`
- `cidr` -> `cidr_block` to match Terraform AWS provider
- `enable_ipv6` -> `assign_generated_ipv6_cidr_block` to match Terraform AWS provider
- `aws_default_route_table.default` -> `aws_default_route_table.this` to align convention

### Added

- Added `destination_prefix_list_id` attribute for default route table route(s)
- Added `var.default_route_table_name` variable to allow setting route table name and align with rest of default resources
- Added support for `aws_default_vpc_dhcp_options`

### Modified

- `secondary_cidr_blocks` was changed from a `count`/list in the `aws_vpc_ipv4_cidr_block_association` resource to a `for_each`/toset(list)
- `manage_default_security_group` default value changed from `false` to `true`
- Tags for custom names have been updated to coalesce with `"default-${var.name}"` if a custom name is not provided instead of defaulting to `""`
- Default route table `timeouts` that were hardcoded at `5m` have been replaced with a variable `var.default_route_table_timeouts` that default to null

#### Breaking

- Default network ACLs ingress and egress rules are now cleared when adopted to conform with AWS recommended practices. Users will need to specify ingress/egress rules if they decide to use the default ACL


### State Move

```bash
  terraform state mv 'module.vpc.aws_default_route_table.default[0]' 'module.vpc.aws_default_route_table.this[0]'
```
