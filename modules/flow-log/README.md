# AWS Flow Log Terraform Module

Terraform module which creates AWS Flow Log resources.

## Usage

See [`examples/`](https://github.com/clowdhaus/terraform-aws-vpc-v4/tree/main/examples) directory for working examples to reference:

```hcl
module "flow_log" {
  source = "terraform-aws-modules/vpc/aws//modules/flow-log"

  name   = "Example"
  vpc_id = "vpc-12345678"

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
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_iam_role_arn"></a> [cloudwatch\_iam\_role\_arn](#input\_cloudwatch\_iam\_role\_arn) | Existing IAM role ARN for the cluster. Required if `create_iam_role` is set to `false` | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_kms_key_id"></a> [cloudwatch\_log\_group\_kms\_key\_id](#input\_cloudwatch\_log\_group\_kms\_key\_id) | The ARN of the KMS Key to use when encrypting log data for logs | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | The name of the CloudWatch Log Group | `string` | `""` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group for logs | `number` | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created; affects all resources | `bool` | `true` | no |
| <a name="input_create_cloudwatch_iam_role"></a> [create\_cloudwatch\_iam\_role](#input\_create\_cloudwatch\_iam\_role) | Determines whether a an IAM role is created or to use an existing IAM role | `bool` | `false` | no |
| <a name="input_create_cloudwatch_log_group"></a> [create\_cloudwatch\_log\_group](#input\_create\_cloudwatch\_log\_group) | Whether to create CloudWatch log group for logs | `bool` | `false` | no |
| <a name="input_destination_arn"></a> [destination\_arn](#input\_destination\_arn) | The ARN of the CloudWatch log group or S3 bucket where logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. Required when `create_cloudwatch_log_group` is `false` | `string` | `""` | no |
| <a name="input_destination_type"></a> [destination\_type](#input\_destination\_type) | Type of flow log destination. One of `s3` or `cloud-watch-logs` | `string` | `null` | no |
| <a name="input_eni_id"></a> [eni\_id](#input\_eni\_id) | The ID of the ENI to attach the flow log to | `string` | `null` | no |
| <a name="input_file_format"></a> [file\_format](#input\_file\_format) | The format for the flow log. Valid values: `plain-text`, `parquet` | `string` | `null` | no |
| <a name="input_hive_compatible_partitions"></a> [hive\_compatible\_partitions](#input\_hive\_compatible\_partitions) | Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3 | `bool` | `null` | no |
| <a name="input_iam_role_description"></a> [iam\_role\_description](#input\_iam\_role\_description) | Description of the role | `string` | `null` | no |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | Cluster IAM role path | `string` | `null` | no |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the IAM role | `string` | `null` | no |
| <a name="input_log_format"></a> [log\_format](#input\_log\_format) | The fields to include in the flow log record, in the order in which they should appear | `string` | `null` | no |
| <a name="input_max_aggregation_interval"></a> [max\_aggregation\_interval](#input\_max\_aggregation\_interval) | The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds | `number` | `null` | no |
| <a name="input_per_hour_partition"></a> [per\_hour\_partition](#input\_per\_hour\_partition) | Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries | `bool` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet to attach the flow log to | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_traffic_type"></a> [traffic\_type](#input\_traffic\_type) | The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL | `string` | `"ALL"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to attach the flow log to | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The VPC flow log ARN |
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | ARN of cloudwatch log group created |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of cloudwatch log group created |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of the flow log CloudWatch IAM role |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of the flow log CloudWatch IAM role |
| <a name="output_iam_role_unique_id"></a> [iam\_role\_unique\_id](#output\_iam\_role\_unique\_id) | Stable and unique string identifying the flow log CloudWatch IAM role |
| <a name="output_id"></a> [id](#output\_id) | The VPC flow log ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-vpc-v4/blob/main/LICENSE).
