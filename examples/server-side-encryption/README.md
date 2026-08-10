# Server-side encryption

Side-by-side comparison of the two supported encryption modes, see
[Choosing between SSE-ONE and SSE-KMS](../../README.md#choosing-between-sse-one-and-sse-kms)
in the root README for details:

- `sse_one_bucket` uses SSE-ONE (`AES256`), Scaleway-managed keys.
- `sse_kms_bucket` uses SSE-KMS (`aws:kms`) with a pre-existing Key Manager
  key, and enables a bucket key to reduce the number of calls made to Key
  Manager.

## Usage

`sse_kms_bucket` needs a real, pre-existing Key Manager key: replace the placeholder `kms_master_key_id` in `main.tf` with your own key ID before applying.

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```
