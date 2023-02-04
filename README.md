# Terraform / Scaleway

## Purpose

This repository is used to manage object storage buckets on scaleway using terraform.

## Usage

- Setup the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) in your tf file.
- Include this module in your tf file. Refer to [documentation](https://www.terraform.io/docs/modules/sources.html#generic-git-repository).

```hcl
module "my_bucket" {
  source  = "scaleway-terraform-modules/bucket/scaleway"
  version = "0.0.1"

}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement_scaleway) | >= 2.7.0 |

## Resources

| Name | Type |
|------|------|
| [scaleway_object_bucket.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket) | resource |
| [scaleway_object_bucket_lock_configuration.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket_lock_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input_name) | Name of the bucket. | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force_destroy](#input_force_destroy) | Enable deletion of objects in bucket before destroying, locked objects or under legal hold are also deleted and not recoverable. | `bool` | `false` | no |
| <a name="input_versioning_enabled"></a> [versioning_enabled](#input_versioning_enabled) | Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. | `bool` | `false` | no |
| <a name="input_versioning_lock_configuration"></a> [versioning_lock_configuration](#input_versioning_lock_configuration) | Specifies the Object Lock rule for the bucket. Requires versioning. | ```object({ mode = string, days = optional(number), years = optional(number), })``` | ```{ "days": null, "mode": "GOVERNANCE", "years": null }``` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_endpoint"></a> [bucket_endpoint](#output_bucket_endpoint) | n/a |
| <a name="output_bucket_id"></a> [bucket_id](#output_bucket_id) | n/a |
<!-- END_TF_DOCS -->

## Authors

Module is maintained with help from [the community](https://github.com/scaleway-terraform-modules/terraform-scaleway-bucket/graphs/contributors).

## License

Mozilla Public License 2.0 Licensed. See [LICENSE](https://github.com/scaleway-terraform-modules/terraform-scaleway-bucket/tree/master/LICENSE) for full details.
