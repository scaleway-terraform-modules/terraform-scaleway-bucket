module "bucket" {
  source = "../.."

  name = "my-lifecycle-managed-bucket"

  versioning_enabled = true

  lifecycle_rules = [
    {
      id      = "archive-large-logs"
      prefix  = "logs/"
      enabled = true

      # Only archive objects bigger than 1 KiB, small ones are not worth transitioning.
      object_size_greater_than = 1024

      transition = {
        days          = 100
        storage_class = "GLACIER"
      }

      # 'days', 'date' and 'expired_object_delete_marker' are mutually exclusive:
      # pick a single one per rule.
      expiration = {
        days = 365
      }

      # Keep the last 3 noncurrent versions for a month, then archive and expire the rest.
      noncurrent_version_transitions = [
        {
          noncurrent_days           = 90
          newer_noncurrent_versions = 3
          storage_class             = "GLACIER"
        }
      ]

      noncurrent_version_expiration = {
        noncurrent_days           = 90
        newer_noncurrent_versions = 3
      }
    },
    {
      id      = "expire-temp-files-on-fixed-date"
      prefix  = "tmp/"
      enabled = true

      expiration = {
        date = "2030-01-01"
      }

      abort_incomplete_multipart_upload_days = 7
    },
    {
      # Versioned buckets can accumulate delete markers with no noncurrent versions
      # behind them (e.g. once those versions expired); clean those up automatically.
      id      = "clean-up-stale-delete-markers"
      enabled = true

      expiration = {
        expired_object_delete_marker = true
      }
    }
  ]
}
