# Bucket policy

Attaches a bucket policy that gives one user full access to the bucket and
lets anyone read its objects. Both principals use the `{ SCW = ... }` form,
including the public one (`{ SCW = "*" }`), so the policy can mix them.

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply -var user_id=<your user ID>
```
