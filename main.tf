resource "scaleway_object_bucket" "this" {
  force_destroy       = var.force_destroy
  name                = var.name
  object_lock_enabled = var.versioning_enabled

  region     = var.region
  project_id = var.project_id
  tags       = zipmap(var.tags, var.tags)

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
