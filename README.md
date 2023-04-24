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
| [scaleway_object_bucket.main](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket) | resource |
| [scaleway_object_bucket_lock_configuration.main](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/object_bucket_lock_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input_name) | Name of the bucket. | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force_destroy](#input_force_destroy) | Enable deletion of objects in bucket before destroying, locked objects or under legal hold are also deleted and not recoverable. | `bool` | `false` | no |
| <a name="input_project_id"></a> [project_id](#input_project_id) | ID of the project the bucket is associated with. If null, ressources will be created in the default project associated with the key. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input_region) | Region in which the bucket should be created. Ressource will be created in the region set at the provider level if null. | `string` | `null` | no |
| <a name="input_versioning_enabled"></a> [versioning_enabled](#input_versioning_enabled) | Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. | `bool` | `false` | no |
| <a name="input_versioning_lock_configuration"></a> [versioning_lock_configuration](#input_versioning_lock_configuration) | Specifies the Object Lock rule for the bucket. Requires versioning. | ```object({ mode = string, days = optional(number), years = optional(number), })``` | ```{ "days": null, "mode": "GOVERNANCE", "years": null }``` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_endpoint"></a> [bucket_endpoint](#output_bucket_endpoint) | Endpoint URL of the bucket. |
| <a name="output_bucket_id"></a> [bucket_id](#output_bucket_id) | Unique name of the bucket. |
<!-- END_TF_DOCS -->


## Exemple

```
## create project
resource "scaleway_account_project" "project" {
  name = "infra_as_codetest"
}

## create bucket
module "create_bucket" {
  source = "/opt/terraform/modules/scaleway/terraform-scaleway-bucket"

  name = "testterra"
  project_id = scaleway_account_project.project.id
  force_destroy = false
  versioning_enabled = false

  tags = [ "tag1", "tag2"]

  lifecycle_rule = {
    id1 = {
        prefix = "path1/"
        expiration = "365"
        transition = "120"
        storage_class = "GLACIER"
    }
    id2 = {
        prefix = "path2"
        expiration = "50"
    }
    id3 = {
        prefix = "path3"
        enabled = false
        expiration = "1"
    }
    id4 = {
        prefix = "path4"
        transition = "0"
        storage_class = "GLACIER"
    }
    id5 = {
        tags = {
            "tagKey"    = "tagValue"
            "terraform" = "hashicorp"
        }
        abort_incomplete_multipart_upload_days = "30"
    }
  }

  website_index = "index.html"

  policy = {
    Version = "2012-10-17"
    Id = "MyBucketPolicytest"
    Statement = [
      {
        Sid = "Restriction d'ips"
        Effect = "Allow"
        Principal = {
          SCW = "*"
        }
        Action = ["s3:ListBucket", "s3:GetObject"],
        Resource = ["testterra", "testterra/*"],
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "10.11.12.0/24"
          }
        }
      }
    ]
  }
}

```


## Authors

Module is maintained with help from [the community](https://github.com/scaleway-terraform-modules/terraform-scaleway-bucket/graphs/contributors).

## License

Mozilla Public License 2.0 Licensed. See [LICENSE](https://github.com/scaleway-terraform-modules/terraform-scaleway-bucket/tree/master/LICENSE) for full details.
