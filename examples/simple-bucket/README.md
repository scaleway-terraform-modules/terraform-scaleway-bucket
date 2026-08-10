# Simple bucket

Minimal setup: a private bucket with no additional configuration. All other
features (versioning, lifecycle, encryption, website hosting, ...) stay
disabled and rely on the module defaults.

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```
