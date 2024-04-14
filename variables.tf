variable "acl" {
  description = "Canned ACL to apply to the bucket. See AWS (documentation)[https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl] for more information."
  type        = string
  default     = "private"
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
    abort_incomplete_multipart_upload_days = optional(number)
    expiration = optional(object({
      days = string
    }))
    transition = optional(object({
      days          = number
      storage_class = string
    }))
  }))
  default = []
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
      Principal = string
      Action    = list(string)
      Resource  = list(string)
    }))
  })
  default = null
}

variable "project_id" {
  description = "ID of the project the bucket is associated with. If null, ressources will be created in the default project associated with the key."
  type        = string
  default     = null
}

variable "region" {
  description = "Region in which the bucket should be created. Ressource will be created in the region set at the provider level if null."
  type        = string
  default     = null
}

variable "tags" {
  description = "A list of tags for the bucket. As the Scaleway console does not support key/value tags, tags are written with the format value/value."
  type        = list(string)
  default     = []
}

variable "versioning_enabled" {
  description = "Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket."
  type        = bool
  default     = false
}

variable "versioning_lock_configuration" {
  description = "Specifies the Object Lock rule for the bucket. Requires versioning."
  type = object({
    mode  = string,
    days  = optional(number),
    years = optional(number),
  })
  default = {
    mode  = "GOVERNANCE"
    days  = null,
    years = null,
  }
}

variable "website_index" {
  description = "Website Configuration."
  type        = string
  default     = null
}
