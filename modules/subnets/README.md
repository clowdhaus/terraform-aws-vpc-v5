# AWS Subnets Terraform Module

Terraform module which creates AWS VPC Subnet resources.

This module is designed to create a set of one or more subnets that serve a desired purpose. For example, one module definition would be used for public subnets, another for private subnets, another for database subnets, etc. This design affords users the ability to create any desired design configuration for a set of subnets, where multiple sets of subnets are composed under the respective VPC to create the desired network topology.

## Usage

See [`examples`](https://github.com/clowdhaus/terraform-aws-vpc-v4/tree/main/examples) directory for working examples to reference:

### Public Subnets

```hcl
module "public_subnets" {
  source = "terraform-aws-modules/vpc/aws//modules/subnets"

  name   = "example-public"
  vpc_id = "vpc-12345678"

  subnets = {
    "us-east-1a" = {
      cidr_block         = "10.98.1.0/24"
      availability_zone  = "us-east-1a"
      create_nat_gateway = true
    }
    "us-east-1b" = {
      cidr_block         = "10.98.2.0/24"
      availability_zone  = "us-east-1b"
      create_nat_gateway = true
    }
    "us-east-1c" = {
      cidr_block         = "10.98.3.0/24"
      availability_zone  = "us-east-1a"
      create_nat_gateway = true
    }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["us-east-1a", "us-east-1a", "us-east-1c"]
      routes = {
        igw = {
          destination_cidr_block = "0.0.0.0/0"
          gateway_id             = "igw-1ff7a07b"
        }
      }
    }
  }

  ingress_network_acl_rules = {
    100 = {
      protocol    = "-1"
      rule_action = "Allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
    }
  }

  egress_network_acl_rules = {
    100 = {
      protocol    = "-1"
      rule_action = "Allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
    }
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
```
### Private Subnets

```hcl
module "private_subnets" {
  source = "terraform-aws-modules/vpc/aws//modules/subnets"

  name   = "example-private"
  vpc_id = "vpc-12345678"

  # TODO

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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dax_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dax_subnet_group) | resource |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_dms_replication_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_subnet_group) | resource |
| [aws_docdb_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_subnet_group) | resource |
| [aws_ec2_subnet_cidr_reservation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_subnet_cidr_reservation) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_elasticache_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_memorydb_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_subnet_group) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_neptune_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_subnet_group) | resource |
| [aws_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_redshift_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_subnet_group) | resource |
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_reservations"></a> [cidr\_reservations](#input\_cidr\_reservations) | Map of CIDR reservations to create | `any` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if network ACL resources should be created | `bool` | `true` | no |
| <a name="input_create_network_acl"></a> [create\_network\_acl](#input\_create\_network\_acl) | Controls creation of Network ACL resources | `bool` | `true` | no |
| <a name="input_dax_subnet_groups"></a> [dax\_subnet\_groups](#input\_dax\_subnet\_groups) | Map of DAX subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dax_subnet_group) | `any` | `{}` | no |
| <a name="input_dms_replication_subnet_groups"></a> [dms\_replication\_subnet\_groups](#input\_dms\_replication\_subnet\_groups) | Map of DMS replication subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_subnet_group) | `any` | `{}` | no |
| <a name="input_docdb_subnet_groups"></a> [docdb\_subnet\_groups](#input\_docdb\_subnet\_groups) | Map of DocumentDB subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_subnet_group) | `any` | `{}` | no |
| <a name="input_elasticache_subnet_groups"></a> [elasticache\_subnet\_groups](#input\_elasticache\_subnet\_groups) | Map of Elasticache subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | `any` | `{}` | no |
| <a name="input_memorydb_subnet_groups"></a> [memorydb\_subnet\_groups](#input\_memorydb\_subnet\_groups) | Map of MemoryDB subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_subnet_group) | `any` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Default name to be used as a prefix for the resources created (if a custom name is not provided) | `string` | `""` | no |
| <a name="input_neptune_subnet_groups"></a> [neptune\_subnet\_groups](#input\_neptune\_subnet\_groups) | Map of Neptune subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_subnet_group) | `any` | `{}` | no |
| <a name="input_network_acl_egress_rules"></a> [network\_acl\_egress\_rules](#input\_network\_acl\_egress\_rules) | Network ACL egresss rules to be added to the Network ACL | `map(any)` | `{}` | no |
| <a name="input_network_acl_ingress_rules"></a> [network\_acl\_ingress\_rules](#input\_network\_acl\_ingress\_rules) | Network ACL ingress rules to be added to the Network ACL | `map(any)` | `{}` | no |
| <a name="input_network_acl_tags"></a> [network\_acl\_tags](#input\_network\_acl\_tags) | Additional tags for the Network ACL | `map(string)` | `{}` | no |
| <a name="input_rds_subnet_groups"></a> [rds\_subnet\_groups](#input\_rds\_subnet\_groups) | Map of RDS Database subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | `any` | `{}` | no |
| <a name="input_redshift_subnet_groups"></a> [redshift\_subnet\_groups](#input\_redshift\_subnet\_groups) | Map of Redshift subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_subnet_group) | `any` | `{}` | no |
| <a name="input_route_table_timeouts"></a> [route\_table\_timeouts](#input\_route\_table\_timeouts) | Create, update, and delete timeout configurations for route table | `map(string)` | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Map of route table definitions | `map(any)` | `{}` | no |
| <a name="input_subnet_timeouts"></a> [subnet\_timeouts](#input\_subnet\_timeouts) | Create and delete timeout configurations for subnets | `map(string)` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnet definitions | `any` | `{}` | no |
| <a name="input_subnets_default"></a> [subnets\_default](#input\_subnets\_default) | Map of subnet default configurations used across all subnets created | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to create the resources in | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arns"></a> [arns](#output\_arns) | List of subnet ARNs |
| <a name="output_dax_subnet_groups"></a> [dax\_subnet\_groups](#output\_dax\_subnet\_groups) | Map of DAX subnet groups created and their attributes |
| <a name="output_dms_replication_subnet_groups"></a> [dms\_replication\_subnet\_groups](#output\_dms\_replication\_subnet\_groups) | Map of DMS Replication subnet groups created and their attributes |
| <a name="output_docdb_subnet_groups"></a> [docdb\_subnet\_groups](#output\_docdb\_subnet\_groups) | Map of DocumentDB subnet groups created and their attributes |
| <a name="output_ec2_subnet_cidr_reservations"></a> [ec2\_subnet\_cidr\_reservations](#output\_ec2\_subnet\_cidr\_reservations) | Map of EC2 subnet CIDR reservations created and their attributes |
| <a name="output_elastic_ips"></a> [elastic\_ips](#output\_elastic\_ips) | Map of EIP(s) created and their attributes |
| <a name="output_elasticache_subnet_groups"></a> [elasticache\_subnet\_groups](#output\_elasticache\_subnet\_groups) | Map of Elasitcache subnet groups created and their attributes |
| <a name="output_ids"></a> [ids](#output\_ids) | List of subnet IDs |
| <a name="output_ipv4_cidr_blocks"></a> [ipv4\_cidr\_blocks](#output\_ipv4\_cidr\_blocks) | List of subnet IPv4 CIDR blocks |
| <a name="output_ipv6_cidr_blocks"></a> [ipv6\_cidr\_blocks](#output\_ipv6\_cidr\_blocks) | List of subnet IPv6 CIDR blocks |
| <a name="output_memorydb_subnet_groups"></a> [memorydb\_subnet\_groups](#output\_memorydb\_subnet\_groups) | Map of MemoryDB subnet groups created and their attributes |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | List of NAT gateway IDs |
| <a name="output_nat_gateway_public_ips"></a> [nat\_gateway\_public\_ips](#output\_nat\_gateway\_public\_ips) | List of NAT gateway public IPs |
| <a name="output_nat_gateways"></a> [nat\_gateways](#output\_nat\_gateways) | Map of NAT gateway(s) created and their attributes |
| <a name="output_neptune_subnet_groups"></a> [neptune\_subnet\_groups](#output\_neptune\_subnet\_groups) | Map of Neptune subnet groups created and their attributes |
| <a name="output_network_acl_arn"></a> [network\_acl\_arn](#output\_network\_acl\_arn) | The ID of the network ACL |
| <a name="output_network_acl_id"></a> [network\_acl\_id](#output\_network\_acl\_id) | The ARN of the network ACL |
| <a name="output_network_acl_rules_egress"></a> [network\_acl\_rules\_egress](#output\_network\_acl\_rules\_egress) | Map of egress network ACL rules created and their attributes |
| <a name="output_network_acl_rules_ingress"></a> [network\_acl\_rules\_ingress](#output\_network\_acl\_rules\_ingress) | Map of ingress network ACL rules created and their attributes |
| <a name="output_rds_subnet_groups"></a> [rds\_subnet\_groups](#output\_rds\_subnet\_groups) | Map of RDS Database subnet groups created and their attributes |
| <a name="output_redshift_subnet_groups"></a> [redshift\_subnet\_groups](#output\_redshift\_subnet\_groups) | Map of DMS Replication subnet groups created and their attributes |
| <a name="output_route_table_gateway_association_ids"></a> [route\_table\_gateway\_association\_ids](#output\_route\_table\_gateway\_association\_ids) | List of gateway route table association IDs |
| <a name="output_route_table_ids"></a> [route\_table\_ids](#output\_route\_table\_ids) | List of route table IDs |
| <a name="output_route_table_subnet_association_ids"></a> [route\_table\_subnet\_association\_ids](#output\_route\_table\_subnet\_association\_ids) | List of subnet route table association IDs |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | Map of route tables created and their attributes |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Map of subnets created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-vpc-v4/blob/main/LICENSE).
