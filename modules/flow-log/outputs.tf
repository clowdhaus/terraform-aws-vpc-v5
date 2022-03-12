
################################################################################
# Flow Log
################################################################################

output "flow_log_arn" {
  description = "The VPC flow log ARN"
  value       = try(aws_flow_log.this[0].arn, null)
}

output "flow_log_id" {
  description = "The VPC flow log ID"
  value       = try(aws_flow_log.this[0].id, null)
}

################################################################################
# Flow Log CloudWatch Log Group
################################################################################

output "flow_log_cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created"
  value       = try(aws_cloudwatch_log_group.this[0].name, null)
}

output "flow_log_cloudwatch_log_group_arn" {
  description = "ARN of cloudwatch log group created"
  value       = try(aws_cloudwatch_log_group.this[0].arn, null)
}

################################################################################
# Flow Log CloudWatch Log Group IAM Role
################################################################################

output "flow_log_iam_role_name" {
  description = "Name of the flow log CloudWatch IAM role"
  value       = try(aws_iam_role.this[0].name, null)
}

output "flow_log_iam_role_arn" {
  description = "ARN of the flow log CloudWatch IAM role"
  value       = try(aws_iam_role.this[0].arn, null)
}

output "flow_log_iam_role_unique_id" {
  description = "Stable and unique string identifying the flow log CloudWatch IAM role"
  value       = try(aws_iam_role.this[0].unique_id, null)
}
