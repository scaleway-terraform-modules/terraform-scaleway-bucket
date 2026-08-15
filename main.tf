resource "scaleway_object_bucket" "this" {
  force_destroy       = var.force_destroy
  name                = var.name
  object_lock_enabled = var.versioning_lock_configuration != null

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
      object_size_greater_than               = lifecycle_rule.value["object_size_greater_than"]
      object_size_less_than                  = lifecycle_rule.value["object_size_less_than"]
      abort_incomplete_multipart_upload_days = lifecycle_rule.value["abort_incomplete_multipart_upload_days"]

      dynamic "expiration" {
        for_each = lifecycle_rule.value["expiration"] == null ? [] : [lifecycle_rule.value["expiration"]]
        content {
          date                         = expiration.value["date"]
          days                         = expiration.value["days"]
          expired_object_delete_marker = expiration.value["expired_object_delete_marker"]
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value["transition"] == null ? [] : [lifecycle_rule.value["transition"]]
        content {
          date          = transition.value["date"]
          days          = transition.value["days"]
          storage_class = transition.value["storage_class"]
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = lifecycle_rule.value["noncurrent_version_expiration"] == null ? [] : [lifecycle_rule.value["noncurrent_version_expiration"]]
        content {
          noncurrent_days           = noncurrent_version_expiration.value["noncurrent_days"]
          newer_noncurrent_versions = noncurrent_version_expiration.value["newer_noncurrent_versions"]
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lifecycle_rule.value["noncurrent_version_transitions"]
        content {
          noncurrent_days           = noncurrent_version_transition.value["noncurrent_days"]
          newer_noncurrent_versions = noncurrent_version_transition.value["newer_noncurrent_versions"]
          storage_class             = noncurrent_version_transition.value["storage_class"]
        }
      }
    }
  }

  dynamic "cors_rule" {
    for_each = length(var.cors_rules) == 0 ? [] : var.cors_rules
    content {
      allowed_headers = cors_rule.value["allowed_headers"]
      allowed_methods = cors_rule.value["allowed_methods"]
      allowed_origins = cors_rule.value["allowed_origins"]
      expose_headers  = cors_rule.value["expose_headers"]
      max_age_seconds = cors_rule.value["max_age_seconds"]
    }
  }

  versioning {
    enabled = var.versioning_enabled || (var.versioning_lock_configuration != null)
  }
}

resource "scaleway_object_bucket_acl" "this" {
  acl    = length(var.acl_grants) == 0 ? var.acl : null
  bucket = scaleway_object_bucket.this.name

  project_id            = var.project_id
  region                = var.region
  expected_bucket_owner = var.acl_expected_bucket_owner

  dynamic "access_control_policy" {
    for_each = length(var.acl_grants) == 0 ? [] : [1]
    content {
      dynamic "grant" {
        for_each = var.acl_grants
        content {
          permission = grant.value["permission"]

          grantee {
            id   = grant.value["grantee_id"]
            type = grant.value["grantee_type"]
            uri  = grant.value["grantee_uri"]
          }
        }
      }

      owner {
        id = var.acl_owner_id
      }
    }
  }

  lifecycle {
    precondition {
      condition     = length(var.acl_grants) == 0 || var.acl_owner_id != null
      error_message = "'acl_owner_id' must be provided when 'acl_grants' is set."
    }
  }
}

resource "scaleway_object_bucket_lock_configuration" "this" {
  count = var.versioning_lock_configuration != null ? 1 : 0

  bucket     = scaleway_object_bucket.this.name
  project_id = var.project_id

  rule {
    default_retention {
      mode  = var.versioning_lock_configuration.mode
      days  = var.versioning_lock_configuration.days
      years = var.versioning_lock_configuration.years
    }
  }

  lifecycle {
    precondition {
      condition     = (var.versioning_lock_configuration.days != null) != (var.versioning_lock_configuration.years != null)
      error_message = "Exactly one of 'days' or 'years' must be provided in 'versioning_lock_configuration'."
    }
  }
}

resource "scaleway_object_bucket_policy" "this" {
  count = var.policy != null ? 1 : 0

  bucket     = scaleway_object_bucket.this.name
  policy     = jsonencode(var.policy)
  project_id = var.project_id
}

resource "scaleway_object_bucket_server_side_encryption_configuration" "this" {
  count = var.sse_algorithm != null ? 1 : 0

  bucket     = scaleway_object_bucket.this.name
  project_id = var.project_id
  region     = var.region

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_master_key_id
    }
    bucket_key_enabled = var.bucket_key_enabled
  }

  lifecycle {
    precondition {
      condition     = var.sse_algorithm != "aws:kms" || var.kms_master_key_id != null
      error_message = "'kms_master_key_id' must be provided when 'sse_algorithm' is set to 'aws:kms'."
    }
    precondition {
      condition     = var.sse_algorithm == "aws:kms" || var.kms_master_key_id == null
      error_message = "'kms_master_key_id' can only be set when 'sse_algorithm' is 'aws:kms'."
    }
    precondition {
      condition     = var.sse_algorithm == "aws:kms" || var.bucket_key_enabled == null
      error_message = "'bucket_key_enabled' can only be set when 'sse_algorithm' is 'aws:kms'."
    }
  }
}

resource "scaleway_object_bucket_website_configuration" "this" {
  count = var.website_index != null ? 1 : 0

  bucket     = scaleway_object_bucket.this.name
  project_id = var.project_id

  index_document {
    suffix = var.website_index
  }

  dynamic "error_document" {
    for_each = var.website_error_document != null ? [var.website_error_document] : []
    content {
      key = error_document.value
    }
  }
}
