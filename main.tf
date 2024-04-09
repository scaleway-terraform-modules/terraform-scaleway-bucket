resource "scaleway_object_bucket" "this" {
  force_destroy       = var.force_destroy
  name                = var.name
  object_lock_enabled = var.versioning_enabled

  region     = var.region
  project_id = var.project_id
  tags       = zipmap(var.tags, var.tags)

  dynamic "lifecycle_rule" {
    for_each = length(var.lifecycle_rules) == 0 ? [] : var.lifecycle_rules
    content {
      id                                     = lifecycle_rule.value["id"]
      prefix                                 = lifecycle_rule.value["prefix"]
      tags                                   = lifecycle_rule.value["tags"]
      enabled                                = lifecycle_rule.value["enabled"]
      abort_incomplete_multipart_upload_days = lifecycle_rule.value["abort_incomplete_multipart_upload_days"]

      dynamic "expiration" {
        for_each = lifecycle_rule.value["expiration"]
        content {
          days = expiration.value["days"]
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value["transition"]
        content {
          days          = transition.value["days"]
          storage_class = transition.value["storage_class"]
        }
      }
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }
}

resource "scaleway_object_bucket_acl" "this" {
  acl    = var.acl
  bucket = scaleway_object_bucket.this.name

  project_id = var.project_id
  region     = var.region
}

resource "scaleway_object_bucket_lock_configuration" "this" {
  count = var.versioning_enabled ? 1 : 0

  bucket     = scaleway_object_bucket.this.name
  project_id = var.project_id

  rule {
    default_retention {
      mode  = var.versioning_lock_configuration["mode"]
      days  = var.versioning_lock_configuration["days"]
      years = var.versioning_lock_configuration["years"]
    }
  }
}

resource "scaleway_object_bucket_policy" "this" {
  count = var.policy != null ? 1 : 0

  bucket     = scaleway_object_bucket.this.name
  policy     = jsonencode(var.policy)
  project_id = var.project_id
}

resource "scaleway_object_bucket_website_configuration" "this" {
  count = var.website_index != null ? 1 : 0

  bucket     = scaleway_object_bucket.this.name
  project_id = var.project_id

  index_document {
    suffix = var.website_index
  }
}
