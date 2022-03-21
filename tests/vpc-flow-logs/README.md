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
tf state mv 'module.vpc.aws_route_table.public[0]'  'module.public_route_table.aws_route_table.this[0]'
tf state mv 'module.vpc.aws_route_table_association.public[0]' 'module.public_subnets.aws_route_table_association.this["eu-west-1a"]'

tf state mv 'module.vpc.aws_route.public_internet_gateway[0]' 'module.public_route_table.aws_route.this["igw"]'

tf state mv 'module.vpc.aws_cloudwatch_log_group.flow_log[0]' 'module.vpc_flow_log.aws_cloudwatch_log_group.this[0]'
tf state mv 'module.vpc.aws_flow_log.this[0]' 'module.vpc_flow_log.aws_flow_log.this[0]'
tf state mv 'module.vpc.aws_iam_role.vpc_flow_log_cloudwatch[0]' 'module.vpc_flow_log.aws_iam_role.this[0]'

# Importing internet gateway attachment can be performed following documentation provided by AWS provider
# https://registry.terraform.io/providers/hashicorp%20%20/aws/latest/docs/resources/internet_gateway_attachment#import
# tf import 'module.vpc.aws_internet_gateway_attachment.this[0]' <igw-id>:<vpc-id>
```
