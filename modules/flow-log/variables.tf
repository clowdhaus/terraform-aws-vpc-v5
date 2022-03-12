variable "create" {
  description = "Controls if resources should be created; affects all resources"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Flow Log
################################################################################

variable "eni_id" {
  description = "The ID of the ENI to attach the flow log to"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "The ID of the subnet to attach the flow log to"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The ID of the VPC to attach the flow log to"
  type        = string
  default     = ""
}

variable "destination_arn" {
  description = "The ARN of the CloudWatch log group or S3 bucket where logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. Required when `create_cloudwatch_log_group` is `false`"
  type        = string
  default     = ""
}

variable "destination_type" {
  description = "Type of flow log destination. One of `s3` or `cloud-watch-logs"
  type        = string
  default     = null
}

variable "log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear"
  type        = string
  default     = null
}

variable "traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL"
  type        = string
  default     = "ALL"
}

variable "max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds"
  type        = number
  default     = null
}

variable "file_format" {
  description = "The format for the flow log. Valid values: `plain-text`, `parquet`"
  type        = string
  default     = null
}

variable "hive_compatible_partitions" {
  description = "Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3"
  type        = bool
  default     = null
}

variable "per_hour_partition" {
  description = "Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries"
  type        = bool
  default     = null
}

################################################################################
# Flow Log CloudWatch Log Group
################################################################################

variable "create_cloudwatch_log_group" {
  description = "Whether to create CloudWatch log group for logs"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Log Group"
  type        = string
  default     = ""
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group for logs"
  type        = number
  default     = null
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data for logs"
  type        = string
  default     = null
}

################################################################################
# Flow Log CloudWatch Log Group IAM Role
################################################################################

variable "create_cloudwatch_iam_role" {
  description = "Determines whether a an IAM role is created or to use an existing IAM role"
  type        = bool
  default     = true
}

variable "cloudwatch_iam_role_arn" {
  description = "Existing IAM role ARN for the cluster. Required if `create_iam_role` is set to `false`"
  type        = string
  default     = null
}

variable "iam_role_path" {
  description = "Cluster IAM role path"
  type        = string
  default     = null
}

variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}
