variable "create" {
  description = "Controls if network ACL resources should be created"
  type        = bool
  default     = true
}

variable "name" {
  description = "Default name to be used as a prefix for the resources created (if a custom name is not provided)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC to create the resources in"
  type        = string
  default     = ""
}

################################################################################
# Subnet
################################################################################

variable "subnets" {
  description = "Map of subnet definitions"
  type        = any
  default     = {}
}

variable "subnets_default" {
  description = "Map of subnet default configurations used across all subnets created"
  type        = any
  default     = {}
}

variable "subnet_timeouts" {
  description = "Create and delete timeout configurations for subnets"
  type        = map(string)
  default     = {}
}

################################################################################
# Subnet Groups
################################################################################

variable "dms_replication_subnet_groups" {
  description = "Map of DMS replication subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_subnet_group)"
  type        = any
  default     = {}
}

variable "docdb_subnet_groups" {
  description = "Map of DocumentDB subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_subnet_group)"
  type        = any
  default     = {}
}

variable "dax_subnet_groups" {
  description = "Map of DAX subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dax_subnet_group)"
  type        = any
  default     = {}
}

variable "elasticache_subnet_groups" {
  description = "Map of Elasticache subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group)"
  type        = any
  default     = {}
}

variable "memorydb_subnet_groups" {
  description = "Map of MemoryDB subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/memorydb_subnet_group)"
  type        = any
  default     = {}
}

variable "neptune_subnet_groups" {
  description = "Map of Neptune subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_subnet_group)"
  type        = any
  default     = {}
}

variable "rds_subnet_groups" {
  description = "Map of RDS Database subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group)"
  type        = any
  default     = {}
}

variable "redshift_subnet_groups" {
  description = "Map of Redshift subnet group [definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_subnet_group)"
  type        = any
  default     = {}
}

################################################################################
# Route Table
################################################################################

variable "route_tables" {
  description = "Map of route table definitions"
  type        = map(any)
  default     = {}
}

variable "route_table_timeouts" {
  description = "Create, update, and delete timeout configurations for route table"
  type        = map(string)
  default     = {}
}

################################################################################
# Network ACL
################################################################################

variable "create_network_acl" {
  description = "Controls creation of Network ACL resources"
  type        = bool
  default     = true
}

variable "network_acl_ingress_rules" {
  description = "Network ACL ingress rules to be added to the Network ACL"
  type        = map(any)
  default     = {}
}

variable "network_acl_egress_rules" {
  description = "Network ACL egresss rules to be added to the Network ACL"
  type        = map(any)
  default     = {}
}

variable "network_acl_tags" {
  description = "Additional tags for the Network ACL"
  type        = map(string)
  default     = {}
}

################################################################################
# NAT Gateway
################################################################################
