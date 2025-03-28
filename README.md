# Terraform / Scaleway

## Purpose

This repository is used to manage object storage buckets on scaleway using terraform.

## Usage

- Setup the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) in your tf file.
- Include this module in your tf file. Refer to [documentation](https://www.terraform.io/docs/modules/sources.html#generic-git-repository).

```hcl
module "my_bucket" {
  source  = "scaleway-terraform-modules/bucket/scaleway"
  version = "~> 1"

  name = "my_bucket"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement_scaleway) | >= 2.10.0 |

## Resources

| Name | Type |
|------|------|
| [scaleway_object_bucket.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket) | resource |
| [scaleway_object_bucket_acl.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket_acl) | resource |
| [scaleway_object_bucket_lock_configuration.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket_lock_configuration) | resource |
| [scaleway_object_bucket_policy.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket_policy) | resource |
| [scaleway_object_bucket_website_configuration.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket_website_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input_name) | Name of the bucket. | `string` | n/a | yes |
| <a name="input_acl"></a> [acl](#input_acl) | Canned ACL to apply to the bucket. See AWS (documentation)[https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl] for more information. | `string` | `"private"` | no |
| <a name="input_force_destroy"></a> [force_destroy](#input_force_destroy) | Enable deletion of objects in bucket before destroying, locked objects or under legal hold are also deleted and not recoverable. | `bool` | `false` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle_rules](#input_lifecycle_rules) | Define bucket lifecycle configuration | ```list(object({ id = string prefix = optional(string) tags = optional(map(string)) enabled = bool abort_incomplete_multipart_upload_days = optional(number) expiration = optional(object({ days = string })) transition = optional(object({ days = number storage_class = string })) }))``` | `[]` | no |
| <a name="input_policy"></a> [policy](#input_policy) | Policy document. For more information about building AWS IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/tutorials/terraform/aws-iam-policy). | ```object({ Version = string, Id = string Statement = list(object({ Sid = string Effect = string Principal = map(any) Action = list(string) Resource = list(string) })) })``` | `null` | no |
| <a name="input_project_id"></a> [project_id](#input_project_id) | ID of the project the bucket is associated with. If null, ressources will be created in the default project associated with the key. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input_region) | Region in which the bucket should be created. Ressource will be created in the region set at the provider level if null. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input_tags) | A list of tags for the bucket. As the Scaleway console does not support key/value tags, tags are written with the format value/value. | `list(string)` | `[]` | no |
| <a name="input_versioning_enabled"></a> [versioning_enabled](#input_versioning_enabled) | Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. **Warning:** This variable is ignored when a lock rule is defined. | `bool` | `false` | no |
| <a name="input_versioning_lock_configuration"></a> [versioning_lock_configuration](#input_versioning_lock_configuration) | Specifies the Object Lock rule for the bucket. Requires versioning. | ```object({ mode = optional(string, "GOVERNANCE"), days = optional(number), years = optional(number), })``` | `null` | no |
| <a name="input_website_index"></a> [website_index](#input_website_index) | Website Configuration. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_endpoint"></a> [bucket_endpoint](#output_bucket_endpoint) | Endpoint URL of the bucket. |
| <a name="output_bucket_id"></a> [bucket_id](#output_bucket_id) | Unique name of the bucket. |
| <a name="output_s3_website_information"></a> [s3_website_information](#output_s3_website_information) | S3 Website information |
<!-- END_TF_DOCS -->

## Authors

Module is maintained with help from [the community](https://github.com/scaleway-terraform-modules/terraform-scaleway-bucket/graphs/contributors).

## License

Mozilla Public License 2.0 Licensed. See [LICENSE](https://github.com/scaleway-terraform-modules/terraform-scaleway-bucket/tree/master/LICENSE) for full details.
