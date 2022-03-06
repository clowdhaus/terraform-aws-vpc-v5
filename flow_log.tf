locals {
  create_flow_log                      = var.create && var.create_flow_log
  create_flow_log_cloudwatch           = local.create_flow_log && var.flow_log_destination_type != "s3"
  create_flow_log_cloudwatch_iam_role  = local.create_flow_log_cloudwatch && var.create_flow_log_cloudwatch_iam_role
  create_flow_log_cloudwatch_log_group = local.create_flow_log_cloudwatch && var.create_flow_log_cloudwatch_log_group

  flow_log_destination_arn = local.create_flow_log_cloudwatch_log_group ? aws_cloudwatch_log_group.flow_log[0].arn : var.flow_log_destination_arn
}

################################################################################
# Flow Log
################################################################################

resource "aws_flow_log" "this" {
  count = local.create_flow_log ? 1 : 0

  vpc_id = local.vpc_id

  iam_role_arn             = local.create_flow_log_cloudwatch_iam_role ? aws_iam_role.flow_log_cloudwatch[0].arn : var.flow_log_cloudwatch_iam_role_arn
  log_destination          = local.flow_log_destination_arn
  log_destination_type     = var.flow_log_destination_type
  log_format               = var.flow_log_log_format
  traffic_type             = var.flow_log_traffic_type
  max_aggregation_interval = var.flow_log_max_aggregation_interval

  dynamic "destination_options" {
    for_each = var.flow_log_destination_type == "s3" ? [1] : []

    content {
      file_format                = var.flow_log_file_format
      hive_compatible_partitions = var.flow_log_hive_compatible_partitions
      per_hour_partition         = var.flow_log_per_hour_partition
    }
  }

  tags = merge(
    var.tags,
    { Name = var.name },
    var.flow_log_tags
  )
}

################################################################################
# Flow Log CloudWatch Log Group
################################################################################

resource "aws_cloudwatch_log_group" "flow_log" {
  count = local.create_flow_log_cloudwatch_log_group ? 1 : 0

  name              = "${var.flow_log_cloudwatch_log_group_name_prefix}${local.vpc_id}"
  retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  kms_key_id        = var.flow_log_cloudwatch_log_group_kms_key_id

  tags = merge(var.tags, var.flow_log_tags)
}

################################################################################
# Flow Log CloudWatch Log Group IAM Role
################################################################################

resource "aws_iam_role" "flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  name_prefix = "vpc-flow-log-role-"
  path        = var.flow_log_iam_role_path
  description = var.flow_log_iam_role_description

  assume_role_policy    = data.aws_iam_policy_document.flow_log_cloudwatch_assume[0].json
  permissions_boundary  = var.flow_log_iam_role_permissions_boundary
  force_detach_policies = true

  inline_policy {
    name   = "vpc-flow-log-to-cloudwatch"
    policy = data.aws_iam_policy_document.flow_log_cloudwatch[0].json
  }

  tags = merge(var.tags, var.flow_log_tags)
}

data "aws_iam_policy_document" "flow_log_cloudwatch_assume" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  statement {
    sid     = "AWSVPCFlowLogsAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

data "aws_iam_policy_document" "flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  statement {
    sid = "AWSVPCFlowLogsPushToCloudWatch"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      local.flow_log_destination_arn,
      "${local.flow_log_destination_arn}:log-stream:*"
    ]
  }
}
