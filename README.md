# Terraform / Scaleway

## Purpose

This repository is used to manage object storage buckets on scaleway using terraform.

- ### Encryption and existing objects

The `sse_algorithm` setting only governs how *new* objects are stored. Objects already present in the bucket are not re-encrypted when encryption is turned on, and remain encrypted when it is turned off. To converge existing objects to the current policy, rewrite them in place, e.g.:

```sh
aws --endpoint-url https://s3.<region>.scw.cloud \
    s3 cp s3://<bucket>/ s3://<bucket>/ \
    --recursive --metadata-directive REPLACE
```

- ### Choosing between SSE-ONE and SSE-KMS

Set `sse_algorithm` to `AES256` for SSE-ONE: Scaleway generates and manages the encryption keys for you, no further configuration is required. Set it to `aws:kms` for SSE-KMS instead, and provide the ID of a pre-existing Scaleway Key Manager key through `kms_master_key_id` (the key itself is not managed by this module, e.g. create it with a dedicated Key Manager module). `bucket_key_enabled` is only relevant for SSE-KMS and reduces the number of calls made to Key Manager when encrypting objects.

- ### Static website hosting

Set `website_index` to serve a static website from the bucket, and optionally `website_error_document` for a custom 4XX error page (both are ignored if `website_index` is left unset). Use `cors_rules` to let browsers on other origins fetch objects from the bucket, e.g. to load assets referenced by the website.

- ### Lifecycle rule expiration fields are mutually exclusive

Within a single `lifecycle_rules[].expiration` block, `days`, `date` and `expired_object_delete_marker` are mutually exclusive: set exactly one of them per rule. `noncurrent_version_expiration` and `noncurrent_version_transitions` apply to noncurrent object versions instead (relevant when versioning is enabled), independently from `expiration`/`transition` which only apply to the current version.

- ### Custom ACL grants

Set `acl_grants` (with the required `acl_owner_id`) to grant fine-grained permissions to specific grantees instead of using a canned ACL. When set, `acl_grants` takes precedence and `acl` is ignored.

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

See the [examples](examples) folder for runnable configurations covering the most common use-cases (static website hosting, lifecycle management, server-side encryption, custom ACL grants).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.4.0 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement_scaleway) | >= 2.77.0 |

## Resources

| Name | Type |
|------|------|
| [scaleway_object_bucket.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket) | resource |
| [scaleway_object_bucket_acl.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket_acl) | resource |
| [scaleway_object_bucket_lock_configuration.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket_lock_configuration) | resource |
| [scaleway_object_bucket_policy.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket_policy) | resource |
| [scaleway_object_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket_server_side_encryption_configuration) | resource |
| [scaleway_object_bucket_website_configuration.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket_website_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input_name) | Name of the bucket. | `string` | n/a | yes |
| <a name="input_acl"></a> [acl](#input_acl) | Canned ACL to apply to the bucket. See [AWS documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl) for more information. Ignored when `acl_grants` is set. | `string` | `"private"` | no |
| <a name="input_acl_expected_bucket_owner"></a> [acl_expected_bucket_owner](#input_acl_expected_bucket_owner) | Project ID of the expected bucket owner, used to verify the bucket ownership. | `string` | `null` | no |
| <a name="input_acl_grants"></a> [acl_grants](#input_acl_grants) | Custom ACL grants for the bucket, as an alternative to a canned `acl`. Conflicts with `acl`: when set, `acl` is ignored. | ```list(object({ grantee_id = optional(string) grantee_type = string grantee_uri = optional(string) permission = string }))``` | `[]` | no |
| <a name="input_acl_owner_id"></a> [acl_owner_id](#input_acl_owner_id) | ID of the bucket owner. Required when `acl_grants` is set. | `string` | `null` | no |
| <a name="input_bucket_key_enabled"></a> [bucket_key_enabled](#input_bucket_key_enabled) | Whether to use a Scaleway Object Bucket Key to reduce the number of calls made to Key Manager when encrypting objects with SSE-KMS. Only applies when `sse_algorithm` is `aws:kms`. | `bool` | `null` | no |
| <a name="input_cors_rules"></a> [cors_rules](#input_cors_rules) | CORS rules applied to the bucket. | ```list(object({ allowed_headers = optional(list(string)) allowed_methods = list(string) allowed_origins = list(string) expose_headers = optional(list(string)) max_age_seconds = optional(number) }))``` | `[]` | no |
| <a name="input_force_destroy"></a> [force_destroy](#input_force_destroy) | Enable deletion of objects in bucket before destroying, locked objects or under legal hold are also deleted and not recoverable. | `bool` | `false` | no |
| <a name="input_kms_master_key_id"></a> [kms_master_key_id](#input_kms_master_key_id) | Scaleway Key Manager key ID used for SSE-KMS encryption. The key must be created beforehand, e.g. with a dedicated Key Manager module. Required when `sse_algorithm` is `aws:kms`, must be left unset otherwise. | `string` | `null` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle_rules](#input_lifecycle_rules) | Define bucket lifecycle configuration | ```list(object({ id = string prefix = optional(string) tags = optional(map(string)) enabled = bool object_size_greater_than = optional(number) object_size_less_than = optional(number) abort_incomplete_multipart_upload_days = optional(number) expiration = optional(object({ date = optional(string) days = optional(number) expired_object_delete_marker = optional(bool) })) transition = optional(object({ date = optional(string) days = optional(number) storage_class = string })) noncurrent_version_expiration = optional(object({ noncurrent_days = optional(number) newer_noncurrent_versions = optional(number) })) noncurrent_version_transitions = optional(list(object({ noncurrent_days = optional(number) newer_noncurrent_versions = optional(number) storage_class = string })), []) }))``` | `[]` | no |
| <a name="input_policy"></a> [policy](#input_policy) | Policy document. For more information about building AWS IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/tutorials/terraform/aws-iam-policy). | ```object({ Version = string, Id = string Statement = list(object({ Sid = string Effect = string Principal = any Action = list(string) Resource = list(string) })) })``` | `null` | no |
| <a name="input_project_id"></a> [project_id](#input_project_id) | ID of the project the bucket is associated with. If null, resources will be created in the default project associated with the key. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input_region) | Region in which the bucket should be created. Resource will be created in the region set at the provider level if null. | `string` | `null` | no |
| <a name="input_sse_algorithm"></a> [sse_algorithm](#input_sse_algorithm) | Server-side encryption algorithm to use. Valid values are `AES256` (SSE-ONE, Scaleway-managed keys) or `aws:kms` (SSE-KMS, customer-managed key). This setting only affects newly uploaded objects; existing objects keep their current encryption state. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input_tags) | A list of tags for the bucket. As the Scaleway console does not support key/value tags, tags are written with the format value/value. | `list(string)` | `[]` | no |
| <a name="input_versioning_enabled"></a> [versioning_enabled](#input_versioning_enabled) | Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. **Warning:** This variable is ignored when a lock rule is defined. | `bool` | `false` | no |
| <a name="input_versioning_lock_configuration"></a> [versioning_lock_configuration](#input_versioning_lock_configuration) | Specifies the Object Lock rule for the bucket. Requires versioning. | ```object({ mode = optional(string, "GOVERNANCE"), days = optional(number), years = optional(number), })``` | `null` | no |
| <a name="input_website_error_document"></a> [website_error_document](#input_website_error_document) | Key of the object to return when a 4XX error occurs while serving the website. Ignored (no website configuration is created) when `website_index` is not set. | `string` | `null` | no |
| <a name="input_website_index"></a> [website_index](#input_website_index) | Key of the object to serve as the homepage when the bucket is used for static website hosting. Set to enable website hosting; leave unset to disable it. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_endpoint"></a> [bucket_endpoint](#output_bucket_endpoint) | Endpoint URL of the bucket. |
| <a name="output_bucket_id"></a> [bucket_id](#output_bucket_id) | Unique name of the bucket. |
| <a name="output_s3_website_information"></a> [s3_website_information](#output_s3_website_information) | S3 Website information |
| <a name="output_server_side_encryption"></a> [server_side_encryption](#output_server_side_encryption) | Server-side encryption configuration of the bucket. |
<!-- END_TF_DOCS -->

## Authors

Module is maintained with help from [the community](https://github.com/scaleway-terraform-modules/terraform-scaleway-bucket/graphs/contributors).

## License

Mozilla Public License 2.0 Licensed. See [LICENSE](https://github.com/scaleway-terraform-modules/terraform-scaleway-bucket/tree/master/LICENSE) for full details.
