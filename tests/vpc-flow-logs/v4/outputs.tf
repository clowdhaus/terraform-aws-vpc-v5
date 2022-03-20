output "vpc_flow_log_id" {
  description = "The ID of the Flow Log resource"
  value       = module.vpc_flow_log.id
}

output "vpc_flow_cloudwatch_log_group_arn" {
  description = "The ARN of the destination for VPC Flow Logs"
  value       = module.vpc_flow_log.cloudwatch_log_group_arn
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
  value       = module.vpc_flow_log.iam_role_arn
}
