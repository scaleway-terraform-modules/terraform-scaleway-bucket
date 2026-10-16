# Bucket policy

Attaches a bucket policy granting public read access to a prefix, full access to
a single user, and read/write access to both a user and an application.

Each statement's `Principal` is a list: use `["*"]` to grant access to anyone,
or list one or more `user_id:<USER_ID>` / `application_id:<APPLICATION_ID>`.
The module renders it as `"*"`, `{"SCW": "<id>"}` or `{"SCW": ["<id>", ...]}`.

## Usage

Replace the placeholder user and application IDs in `main.tf` with your own before applying.
Keep in mind that a bucket policy replaces the default access of the bucket owner:
make sure the identity running Terraform is granted access by one of the statements.

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```
