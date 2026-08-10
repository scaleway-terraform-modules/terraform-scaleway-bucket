variable "acl" {
  description = "Canned ACL to apply to the bucket. See [AWS documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl) for more information. Ignored when `acl_grants` is set."
  type        = string
  default     = "private"
}

variable "acl_grants" {
  description = "Custom ACL grants for the bucket, as an alternative to a canned `acl`. Conflicts with `acl`: when set, `acl` is ignored."
  type = list(object({
    grantee_id   = optional(string)
    grantee_type = string
    grantee_uri  = optional(string)
    permission   = string
  }))
  default = []

  validation {
    condition     = alltrue([for grant in var.acl_grants : contains(["CanonicalUser", "Group"], grant.grantee_type)])
    error_message = "'acl_grants[].grantee_type' must be one of `CanonicalUser` or `Group`."
  }

  validation {
    condition = alltrue([
      for grant in var.acl_grants :
      grant.grantee_type == "CanonicalUser" ? grant.grantee_id != null : grant.grantee_uri != null
    ])
    error_message = "'acl_grants[].grantee_id' is required when 'grantee_type' is `CanonicalUser`, and 'acl_grants[].grantee_uri' is required when 'grantee_type' is `Group`."
  }
}

variable "acl_owner_id" {
  description = "ID of the bucket owner. Required when `acl_grants` is set."
  type        = string
  default     = null
}

variable "acl_expected_bucket_owner" {
  description = "Project ID of the expected bucket owner, used to verify the bucket ownership."
  type        = string
  default     = null
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm to use. Valid values are `AES256` (SSE-ONE, Scaleway-managed keys) or `aws:kms` (SSE-KMS, customer-managed key). This setting only affects newly uploaded objects; existing objects keep their current encryption state."
  type        = string
  default     = null

  validation {
    condition     = var.sse_algorithm == null ? true : contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "'sse_algorithm' must be one of `AES256` or `aws:kms`."
  }
}

variable "kms_master_key_id" {
  description = "Scaleway Key Manager key ID used for SSE-KMS encryption. The key must be created beforehand, e.g. with a dedicated Key Manager module. Required when `sse_algorithm` is `aws:kms`, must be left unset otherwise."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Whether to use a Scaleway Object Bucket Key to reduce the number of calls made to Key Manager when encrypting objects with SSE-KMS. Only applies when `sse_algorithm` is `aws:kms`."
  type        = bool
  default     = null
}

variable "cors_rules" {
  description = "CORS rules applied to the bucket."
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "force_destroy" {
  description = "Enable deletion of objects in bucket before destroying, locked objects or under legal hold are also deleted and not recoverable."
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "Define bucket lifecycle configuration"
  type = list(object({
    id                                     = string
    prefix                                 = optional(string)
    tags                                   = optional(map(string))
    enabled                                = bool
    object_size_greater_than               = optional(number)
    object_size_less_than                  = optional(number)
    abort_incomplete_multipart_upload_days = optional(number)
    expiration = optional(object({
      date                         = optional(string)
      days                         = optional(number)
      expired_object_delete_marker = optional(bool)
    }))
    transition = optional(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = string
    }))
    noncurrent_version_expiration = optional(object({
      noncurrent_days           = optional(number)
      newer_noncurrent_versions = optional(number)
    }))
    noncurrent_version_transitions = optional(list(object({
      noncurrent_days           = optional(number)
      newer_noncurrent_versions = optional(number)
      storage_class             = string
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules : rule.expiration == null || length(compact([
        rule.expiration.days != null ? "days" : "",
        rule.expiration.date != null ? "date" : "",
        rule.expiration.expired_object_delete_marker != null ? "expired_object_delete_marker" : "",
      ])) <= 1
    ])
    error_message = "In 'lifecycle_rules[].expiration', 'days', 'date' and 'expired_object_delete_marker' are mutually exclusive: set at most one of them per rule."
  }
}

variable "name" {
  description = "Name of the bucket."
  type        = string
}

variable "policy" {
  description = "Policy document. For more information about building AWS IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/tutorials/terraform/aws-iam-policy)."
  type = object({
    Version = string,
    Id      = string
    Statement = list(object({
      Sid       = string
      Effect    = string
      Principal = any
      Action    = list(string)
      Resource  = list(string)
    }))
  })
  default = null
}

variable "project_id" {
  description = "ID of the project the bucket is associated with. If null, resources will be created in the default project associated with the key."
  type        = string
  default     = null
}

variable "region" {
  description = "Region in which the bucket should be created. Resource will be created in the region set at the provider level if null."
  type        = string
  default     = null
}

variable "tags" {
  description = "A list of tags for the bucket. As the Scaleway console does not support key/value tags, tags are written with the format value/value."
  type        = list(string)
  default     = []
}

variable "versioning_enabled" {
  description = "Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. **Warning:** This variable is ignored when a lock rule is defined."
  type        = bool
  default     = false
}

variable "versioning_lock_configuration" {
  description = "Specifies the Object Lock rule for the bucket. Requires versioning."
  type = object({
    mode  = optional(string, "GOVERNANCE"),
    days  = optional(number),
    years = optional(number),
  })
  default = null
}

variable "website_error_document" {
  description = "Key of the object to return when a 4XX error occurs while serving the website. Ignored (no website configuration is created) when `website_index` is not set."
  type        = string
  default     = null
}

variable "website_index" {
  description = "Key of the object to serve as the homepage when the bucket is used for static website hosting. Set to enable website hosting; leave unset to disable it."
  type        = string
  default     = null
}
