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
# EC2 Subnet CIDR Reservation
################################################################################

variable "cidr_reservations" {
  description = "Map of CIDR reservations to create"
  type        = any
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
