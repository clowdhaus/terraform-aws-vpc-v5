# First - Provision v4

```bash
cd v4
tf init -upgrade=true
tf apply
tf apply -refresh-only
tf plan # ensure state is clean before proceeding
```

# Second - Migrate State via `state mv`

```bash
cd v5

tf state mv 'module.vpc.aws_subnet.public[0]' 'module.public_subnets.aws_subnet.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_subnet.public[1]' 'module.public_subnets.aws_subnet.this["eu-west-1b"]'

tf state mv 'module.vpc.aws_subnet.private[0]' 'module.private_subnets.aws_subnet.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_subnet.private[1]' 'module.private_subnets.aws_subnet.this["eu-west-1b"]'

tf state mv 'module.vpc.aws_subnet.database[0]' 'module.database_subnets.aws_subnet.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_subnet.database[1]' 'module.database_subnets.aws_subnet.this["eu-west-1b"]'

tf state mv 'module.vpc.aws_route_table.public[0]'  'module.public_route_table.aws_route_table.this[0]'
tf state mv 'module.vpc.aws_route_table.private[0]' 'module.private_route_tables["eu-west-1a"].aws_route_table.this[0]'
tf state mv 'module.vpc.aws_route_table.private[1]' 'module.private_route_tables["eu-west-1b"].aws_route_table.this[0]'
tf state mv 'module.vpc.aws_route_table.database[0]' 'module.database_route_table.aws_route_table.this[0]'

tf state mv 'module.vpc.aws_route_table_association.public[0]' 'module.public_subnets.aws_route_table_association.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table_association.public[1]' 'module.public_subnets.aws_route_table_association.this["eu-west-1b"]'

tf state mv 'module.vpc.aws_route_table_association.private[0]' 'module.private_subnets.aws_route_table_association.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table_association.private[1]' 'module.private_subnets.aws_route_table_association.this["eu-west-1b"]'

tf state mv 'module.vpc.aws_route_table_association.database[0]' 'module.database_subnets.aws_route_table_association.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table_association.database[1]' 'module.database_subnets.aws_route_table_association.this["eu-west-1b"]'

tf state mv 'module.vpc.aws_route.public_internet_gateway_ipv6[0]' 'module.public_route_table.aws_route.this["igw_ipv6"]'
tf state mv 'module.vpc.aws_route.public_internet_gateway[0]' 'module.public_route_table.aws_route.this["igw_ipv4"]'

tf state mv 'module.vpc.aws_route.private_ipv6_egress[0]' 'module.private_route_tables["eu-west-1a"].aws_route.this["eigw_ipv6"]'
tf state mv 'module.vpc.aws_route.private_ipv6_egress[1]' 'module.private_route_tables["eu-west-1b"].aws_route.this["eigw_ipv6"]'

tf state mv 'module.vpc.aws_route.database_ipv6_egress[0]' 'module.database_route_table.aws_route.this["eigw_ipv6"]'
tf state mv 'module.vpc.aws_route.database_internet_gateway[0]' 'module.database_route_table.aws_route.this["igw_ipv4"]'

tf state mv 'module.vpc.aws_db_subnet_group.database[0]' 'module.database_subnets.aws_db_subnet_group.this["database"]'

# Importing internet gateway attachment can be performed following documentation provided by AWS provider
# https://registry.terraform.io/providers/hashicorp%20%20/aws/latest/docs/resources/internet_gateway_attachment#import
# tf import 'module.vpc.aws_internet_gateway_attachment.this[0]' <igw-id>:<vpc-id>
```
