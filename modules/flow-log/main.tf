locals {
  create_cloudwatch           = var.create && var.destination_type != "s3"
  create_cloudwatch_iam_role  = local.create_cloudwatch && var.create_cloudwatch_iam_role
  create_cloudwatch_log_group = local.create_cloudwatch && var.create_cloudwatch_log_group

  destination_arn = local.create_cloudwatch_log_group ? aws_cloudwatch_log_group.this[0].arn : var.destination_arn
}

data "aws_partition" "current" {}

################################################################################
# Flow Log
################################################################################

resource "aws_flow_log" "this" {
  count = var.create ? 1 : 0

  # One of these is required
  eni_id    = var.eni_id
  subnet_id = var.subnet_id
  vpc_id    = var.vpc_id

  iam_role_arn             = local.create_cloudwatch_iam_role ? aws_iam_role.this[0].arn : var.cloudwatch_iam_role_arn
  log_destination          = local.destination_arn
  log_destination_type     = var.destination_type
  log_format               = var.log_format
  traffic_type             = var.traffic_type
  max_aggregation_interval = var.max_aggregation_interval

  dynamic "destination_options" {
    for_each = var.destination_type == "s3" ? [1] : []

    content {
      file_format                = var.file_format
      hive_compatible_partitions = var.hive_compatible_partitions
      per_hour_partition         = var.per_hour_partition
    }
  }

  tags = var.tags
}

################################################################################
# Flow Log CloudWatch Log Group
################################################################################

resource "aws_cloudwatch_log_group" "this" {
  count = local.create_cloudwatch_log_group ? 1 : 0

  name              = var.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id

  tags = var.tags
}

################################################################################
# Flow Log CloudWatch Log Group IAM Role
################################################################################

resource "aws_iam_role" "this" {
  count = local.create_cloudwatch_iam_role ? 1 : 0

  name_prefix = "vpc-flow-log-role-"
  path        = var.iam_role_path
  description = var.iam_role_description

  assume_role_policy    = data.aws_iam_policy_document.assume[0].json
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  inline_policy {
    name   = "vpc-flow-log-to-cloudwatch"
    policy = data.aws_iam_policy_document.this[0].json
  }

  tags = var.tags
}

data "aws_iam_policy_document" "assume" {
  count = local.create_cloudwatch_iam_role ? 1 : 0

  statement {
    sid     = "AWSVPCFlowLogsAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

data "aws_iam_policy_document" "this" {
  count = local.create_cloudwatch_iam_role ? 1 : 0

  statement {
    sid = "AWSVPCFlowLogsPushToCloudWatch"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      local.destination_arn,
      "${local.destination_arn}:log-stream:*"
    ]
  }
}
