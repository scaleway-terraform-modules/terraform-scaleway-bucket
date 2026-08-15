# Static website hosting

Serves a static website directly from the bucket: `website_index` sets the
homepage, `website_error_document` is served for 4XX errors, `acl` grants
public read access, and `cors_rules` lets browsers fetch objects (e.g. fonts,
scripts) from other origins.

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```
