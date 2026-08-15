# Lifecycle management

Three lifecycle rules illustrating the available filters and actions. Note
that within `expiration`, `days`, `date` and `expired_object_delete_marker`
are mutually exclusive: each rule below only uses one of them.

- `archive-large-logs` transitions large, current objects to `GLACIER` after
  30 days, expires them after a year, and separately manages noncurrent
  versions (kept versioned objects from before versioning caught up) by
  transitioning then expiring them, always keeping the 3 most recent ones.
- `expire-temp-files-on-fixed-date` expires objects on a fixed calendar date
  instead of a relative number of days, and cleans up multipart uploads left
  incomplete for more than a week.
- `clean-up-stale-delete-markers` removes delete markers left behind on a
  versioned bucket once they no longer have any noncurrent version attached.

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```
