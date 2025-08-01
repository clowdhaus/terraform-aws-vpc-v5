# IPAM AWS VPC Example

Configuration in this directory creates:

- <TODO>

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which will incur monetary charges on your AWS bill. Run `terraform destroy` when you no longer need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.5 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ipam"></a> [ipam](#module\_ipam) | ../../modules/ipam | n/a |
| <a name="module_ipam_pool_nonprod"></a> [ipam\_pool\_nonprod](#module\_ipam\_pool\_nonprod) | ../../modules/ipam-pool | n/a |
| <a name="module_ipam_pool_prod"></a> [ipam\_pool\_prod](#module\_ipam\_pool\_prod) | ../../modules/ipam-pool | n/a |
| <a name="module_ipam_regional_pool"></a> [ipam\_regional\_pool](#module\_ipam\_regional\_pool) | ../../modules/ipam-pool | n/a |
| <a name="module_vpc_nonprod_euwest1"></a> [vpc\_nonprod\_euwest1](#module\_vpc\_nonprod\_euwest1) | ../../ | n/a |
| <a name="module_vpc_prod_euwest1"></a> [vpc\_prod\_euwest1](#module\_vpc\_prod\_euwest1) | ../../ | n/a |
| <a name="module_vpc_prod_useast1"></a> [vpc\_prod\_useast1](#module\_vpc\_prod\_useast1) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ipam_arn"></a> [ipam\_arn](#output\_ipam\_arn) | Amazon Resource Name (ARN) of IPAM |
| <a name="output_ipam_id"></a> [ipam\_id](#output\_ipam\_id) | The ID of the IPAM |
| <a name="output_ipam_pool_nonprod"></a> [ipam\_pool\_nonprod](#output\_ipam\_pool\_nonprod) | A map of the 'nonproduction' pools created and their attributes |
| <a name="output_ipam_pool_prod"></a> [ipam\_pool\_prod](#output\_ipam\_pool\_prod) | A map of the 'production' pools created and their attributes |
| <a name="output_ipam_private_default_scope_id"></a> [ipam\_private\_default\_scope\_id](#output\_ipam\_private\_default\_scope\_id) | The ID of the IPAM's private scope. A scope is a top-level container in IPAM. Each scope represents an IP-independent network. Scopes enable you to represent networks where you have overlapping IP space. The private scope is intended for private IP space |
| <a name="output_ipam_public_default_scope_id"></a> [ipam\_public\_default\_scope\_id](#output\_ipam\_public\_default\_scope\_id) | The ID of the IPAM's private scope. A scope is a top-level container in IPAM. Each scope represents an IP-independent network. Scopes enable you to represent networks where you have overlapping IP space. The public scope is intended for all internet-routable IP space |
| <a name="output_ipam_regional_pool"></a> [ipam\_regional\_pool](#output\_ipam\_regional\_pool) | A map of the regional pools created and their attributes |
| <a name="output_ipam_scope_count"></a> [ipam\_scope\_count](#output\_ipam\_scope\_count) | The number of scopes in the IPAM |
| <a name="output_ipam_scopes"></a> [ipam\_scopes](#output\_ipam\_scopes) | A map of the scopes created and their attributes |
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](../../LICENSE).
