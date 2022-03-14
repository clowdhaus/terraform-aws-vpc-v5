# First - Provision v3

```bash
cd v3
tf init -upgrade=true
tf apply
tf apply -refresh-only
tf plan # ensure state is clean before proceeding
```

# Second - Migrate State via `state mv`

```bash
cd v4

tf state mv 'module.vpc.aws_subnet.public[0]' 'module.public_subnets.aws_subnet.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_subnet.public[1]' 'module.public_subnets.aws_subnet.this["eu-west-1b"]'

tf state mv 'module.vpc.aws_subnet.private[0]' 'module.private_subnets.aws_subnet.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_subnet.private[1]' 'module.private_subnets.aws_subnet.this["eu-west-1b"]'

tf state mv 'module.vpc.aws_subnet.database[0]' 'module.database_subnets.aws_subnet.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_subnet.database[1]' 'module.database_subnets.aws_subnet.this["eu-west-1b"]'

tf state mv 'module.vpc.aws_route_table.public[0]'  'module.public_subnets.aws_route_table.this["shared"]'
tf state mv 'module.vpc.aws_route_table.private[0]' 'module.private_subnets.aws_route_table.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table.private[1]' 'module.private_subnets.aws_route_table.this["eu-west-1b"]'
tf state mv 'module.vpc.aws_route_table.database[0]' 'module.database_subnets.aws_route_table.this["shared"]'

tf state mv 'module.vpc.aws_route_table_association.public[0]' 'module.public_subnets.aws_route_table_association.subnet["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table_association.public[1]' 'module.public_subnets.aws_route_table_association.subnet["eu-west-1b"]'

tf state mv 'module.vpc.aws_route_table_association.private[0]' 'module.private_subnets.aws_route_table_association.subnet["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table_association.private[1]' 'module.private_subnets.aws_route_table_association.subnet["eu-west-1b"]'

tf state mv 'module.vpc.aws_route_table_association.database[0]' 'module.database_subnets.aws_route_table_association.subnet["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table_association.database[1]' 'module.database_subnets.aws_route_table_association.subnet["eu-west-1b"]'

tf state mv 'module.vpc.aws_route.public_internet_gateway[0]' 'module.public_subnets.aws_route.this["igw_ipv4"]'
# tf state mv 'module.vpc.aws_route.private_nat_gateway[0]' 'module.private_subnets.aws_route.this["nat_gw_ipv4"]'

tf state mv 'module.vpc.aws_egress_only_internet_gateway.this[0]'

tf state mv 'xxxx' 'module.public_subnets.aws_route.this["igw_ipv6"]'

tf state mv 'module.vpc.aws_route.private_ipv6_egress[0]' 'module.private_subnets.aws_route.this["eigw_ipv6"]'
tf state mv 'module.vpc.aws_route.private_ipv6_egress[1]'

tf state mv 'module.vpc.aws_route.public_internet_gateway_ipv6[0]' 'module.public_subnets.aws_route.this["igw_ipv6"]'

tf state mv 'module.vpc.aws_route.database_ipv6_egress[0]' 'module.database_subnets.aws_route.this["eigw_ipv6"]'
tf state mv 'module.vpc.aws_route.database_internet_gateway[0]' 'module.database_subnets.aws_route.this["igw_ipv4"]'

tf state mv 'module.vpc.aws_db_subnet_group.database[0]' 'module.database_subnets.aws_db_subnet_group.this["database"]'
```
