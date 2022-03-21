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
tf state mv 'module.vpc.aws_subnet.public[2]' 'module.public_subnets.aws_subnet.this["eu-west-1c"]'

tf state mv 'module.vpc.aws_subnet.private[0]' 'module.private_subnets.aws_subnet.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_subnet.private[1]' 'module.private_subnets.aws_subnet.this["eu-west-1b"]'
tf state mv 'module.vpc.aws_subnet.private[2]' 'module.private_subnets.aws_subnet.this["eu-west-1c"]'

tf state mv 'module.vpc.aws_subnet.database[0]' 'module.database_subnets.aws_subnet.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_subnet.database[1]' 'module.database_subnets.aws_subnet.this["eu-west-1b"]'
tf state mv 'module.vpc.aws_subnet.database[2]' 'module.database_subnets.aws_subnet.this["eu-west-1c"]'

tf state mv 'module.vpc.aws_subnet.elasticache[0]' 'module.elasticache_subnets.aws_subnet.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_subnet.elasticache[1]' 'module.elasticache_subnets.aws_subnet.this["eu-west-1b"]'
tf state mv 'module.vpc.aws_subnet.elasticache[2]' 'module.elasticache_subnets.aws_subnet.this["eu-west-1c"]'

tf state mv 'module.vpc.aws_subnet.redshift[0]' 'module.redshift_subnets.aws_subnet.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_subnet.redshift[1]' 'module.redshift_subnets.aws_subnet.this["eu-west-1b"]'
tf state mv 'module.vpc.aws_subnet.redshift[2]' 'module.redshift_subnets.aws_subnet.this["eu-west-1c"]'

tf state mv 'module.vpc.aws_subnet.intra[0]' 'module.intra_subnets.aws_subnet.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_subnet.intra[1]' 'module.intra_subnets.aws_subnet.this["eu-west-1b"]'
tf state mv 'module.vpc.aws_subnet.intra[2]' 'module.intra_subnets.aws_subnet.this["eu-west-1c"]'

tf state mv 'module.vpc.aws_route_table.public[0]'  'module.public_route_table.aws_route_table.this[0]'
tf state mv 'module.vpc.aws_route_table.private[0]' 'module.private_route_table.aws_route_table.this[0]'
tf state mv 'module.vpc.aws_route_table.intra[0]' 'module.intra_route_table.aws_route_table.this[0]'

tf state mv 'module.vpc.aws_route_table_association.public[0]' 'module.public_subnets.aws_route_table_association.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table_association.public[1]' 'module.public_subnets.aws_route_table_association.this["eu-west-1b"]'
tf state mv 'module.vpc.aws_route_table_association.public[2]' 'module.public_subnets.aws_route_table_association.this["eu-west-1c"]'

tf state mv 'module.vpc.aws_route_table_association.private[0]' 'module.private_subnets.aws_route_table_association.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table_association.private[1]' 'module.private_subnets.aws_route_table_association.this["eu-west-1b"]'
tf state mv 'module.vpc.aws_route_table_association.private[2]' 'module.private_subnets.aws_route_table_association.this["eu-west-1c"]'

tf state mv 'module.vpc.aws_route_table_association.database[0]' 'module.database_subnets.aws_route_table_association.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table_association.database[1]' 'module.database_subnets.aws_route_table_association.this["eu-west-1b"]'
tf state mv 'module.vpc.aws_route_table_association.database[2]' 'module.database_subnets.aws_route_table_association.this["eu-west-1c"]'

tf state mv 'module.vpc.aws_route_table_association.elasticache[0]' 'module.elasticache_subnets.aws_route_table_association.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table_association.elasticache[1]' 'module.elasticache_subnets.aws_route_table_association.this["eu-west-1b"]'
tf state mv 'module.vpc.aws_route_table_association.elasticache[2]' 'module.elasticache_subnets.aws_route_table_association.this["eu-west-1c"]'

tf state mv 'module.vpc.aws_route_table_association.redshift[0]' 'module.redshift_subnets.aws_route_table_association.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table_association.redshift[1]' 'module.redshift_subnets.aws_route_table_association.this["eu-west-1b"]'
tf state mv 'module.vpc.aws_route_table_association.redshift[2]' 'module.redshift_subnets.aws_route_table_association.this["eu-west-1c"]'

tf state mv 'module.vpc.aws_route_table_association.intra[0]' 'module.intra_subnets.aws_route_table_association.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_route_table_association.intra[1]' 'module.intra_subnets.aws_route_table_association.this["eu-west-1b"]'
tf state mv 'module.vpc.aws_route_table_association.intra[2]' 'module.intra_subnets.aws_route_table_association.this["eu-west-1c"]'

tf state mv 'module.vpc.aws_vpn_gateway.this[0]' 'module.vpc.aws_vpn_gateway.this["one"]'

tf state mv 'module.vpc.aws_nat_gateway.this[0]' 'module.public_subnets.aws_nat_gateway.this["eu-west-1a"]'
tf state mv 'module.vpc.aws_eip.nat[0]' 'module.public_subnets.aws_eip.this["eu-west-1a"]'

tf state mv 'module.vpc.aws_route.public_internet_gateway[0]' 'module.public_route_table.aws_route.this["igw_ipv4"]'
tf state mv 'module.vpc.aws_route.private_nat_gateway[0]' 'module.private_route_table.aws_route.this["nat_gw_ipv4"]'

tf state mv 'module.vpc.aws_default_route_table.default[0]' 'module.vpc.aws_default_route_table.this[0]'

tf state mv 'module.vpc.aws_elasticache_subnet_group.elasticache[0]' 'module.elasticache_subnets.aws_elasticache_subnet_group.this["elasticache"]'
tf state mv 'module.vpc.aws_redshift_subnet_group.redshift[0]' 'module.redshift_subnets.aws_redshift_subnet_group.this["redshift"]'

tf state mv 'module.vpc.aws_cloudwatch_log_group.flow_log[0]' 'module.vpc_flow_log.aws_cloudwatch_log_group.this[0]'
tf state mv 'module.vpc.aws_flow_log.this[0]' 'module.vpc_flow_log.aws_flow_log.this[0]'
tf state mv 'module.vpc.aws_iam_role.vpc_flow_log_cloudwatch[0]' 'module.vpc_flow_log.aws_iam_role.this[0]'

# Importing internet gateway attachment can be performed following documentation provided by AWS provider
# https://registry.terraform.io/providers/hashicorp%20%20/aws/latest/docs/resources/internet_gateway_attachment#import
# tf import 'module.vpc.aws_internet_gateway_attachment.this[0]' <igw-id>:<vpc-id>
```
