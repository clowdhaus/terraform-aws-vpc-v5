# VPC with enabled VPC flow log to S3 and CloudWatch logs

Configuration in this directory creates a set of VPC resources with VPC Flow Logs enabled in different configurations:

1. `cloud-watch-logs.tf` - Push logs to a new AWS CloudWatch Log group.
1. `cloud-watch-logs.tf` - Push logs to an existing AWS CloudWatch Log group using existing IAM role (created outside of this module).
1. `s3.tf` - Push logs to an existing S3 bucket (created outside of this module).

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money (AWS Elastic IP, for example). Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.4 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_public_route_table"></a> [public\_route\_table](#module\_public\_route\_table) | ../../../modules/route-table | n/a |
| <a name="module_public_subnets"></a> [public\_subnets](#module\_public\_subnets) | ../../../modules/subnet | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../../ | n/a |
| <a name="module_vpc_flow_log"></a> [vpc\_flow\_log](#module\_vpc\_flow\_log) | ../../../modules/flow-log | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_flow_cloudwatch_log_group_arn"></a> [vpc\_flow\_cloudwatch\_log\_group\_arn](#output\_vpc\_flow\_cloudwatch\_log\_group\_arn) | The ARN of the destination for VPC Flow Logs |
| <a name="output_vpc_flow_log_cloudwatch_iam_role_arn"></a> [vpc\_flow\_log\_cloudwatch\_iam\_role\_arn](#output\_vpc\_flow\_log\_cloudwatch\_iam\_role\_arn) | The ARN of the IAM role used when pushing logs to Cloudwatch log group |
| <a name="output_vpc_flow_log_id"></a> [vpc\_flow\_log\_id](#output\_vpc\_flow\_log\_id) | The ID of the Flow Log resource |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
