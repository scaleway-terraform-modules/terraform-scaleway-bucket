# Shared access via custom ACL grants

Grants read access to a specific project and to everyone, as an alternative to
the canned `acl` values. Setting `acl_grants` (and the required `acl_owner_id`)
takes precedence over `acl`, which is then ignored.

## Usage

Replace the placeholder `acl_owner_id` and `grantee_id` values in `main.tf` with your own project IDs before applying.

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```
