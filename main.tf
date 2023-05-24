moved {
  from = scaleway_object_bucket.this
  to   = scaleway_object_bucket.main
}

resource "scaleway_object_bucket" "main" {
  force_destroy       = var.force_destroy
  name                = var.name
  object_lock_enabled = var.versioning_enabled

  region     = var.region
  project_id = var.project_id

  tags = var.tags == null ? {} : {
     for tag in var.tags :
     tag => tag
  }

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule
    iterator = terraform_rules
    content {
      id = terraform_rules.key
      enabled = lookup(terraform_rules.value, "enabled", "true")
      prefix = lookup(terraform_rules.value, "prefix", null)
      abort_incomplete_multipart_upload_days = lookup(terraform_rules.value, "abort_incomplete_multipart_upload_days", null)

      tags = lookup(terraform_rules.value, "tags", null) == null ? {} : {
         for key, value in terraform_rules.value.tags :
         key => value
      }

      dynamic "expiration" {
        for_each = length(lookup(terraform_rules.value, "expiration", "")) == 0 ? [] : [terraform_rules.value.expiration]
        content {
            days = terraform_rules.value.expiration
        }
      }

      dynamic "transition" {
        for_each = length(lookup(terraform_rules.value, "transition", "")) == 0 || length(lookup(terraform_rules.value, "storage_class", "")) == 0 ? [] : [terraform_rules.value.transition]
        content {
          days          = terraform_rules.value.transition
          storage_class = terraform_rules.value.storage_class
        }
      }
    }
  }
}

resource "scaleway_object_bucket_lock_configuration" "main" {
  count = var.versioning_enabled ? 1 : 0

  bucket     = scaleway_object_bucket.main.name
  project_id = var.project_id

  rule {
    default_retention {
      mode  = var.versioning_lock_configuration["mode"]
      days  = var.versioning_lock_configuration["days"]
      years = var.versioning_lock_configuration["years"]
    }
  }
}

resource "scaleway_object_bucket_website_configuration" "main" {
  count = var.website_index != null ? 1 : 0

  bucket = scaleway_object_bucket.main.name
  project_id = var.project_id

  index_document {
    suffix = var.website_index
  }
}

resource "scaleway_object_bucket_policy" "policy" {
    count = var.policy != null ? 1 : 0

    bucket = scaleway_object_bucket.main.name
    project_id = var.project_id

    policy = jsonencode(
      var.policy
    )
}
