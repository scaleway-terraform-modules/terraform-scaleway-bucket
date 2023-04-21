variable "name" {
  description = "Name of the bucket."
  type        = string
}

variable "tags" {
  description = "A list of tags (key / value) for the bucket."
  type        = list(any)
  default     = null
}

variable "region" {
  description = "Region in which the bucket should be created. Ressource will be created in the region set at the provider level if null."
  type        = string
  default     = null
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

variable "cors_rule" {
  description = "A rule of Cross-Origin Resource Sharing."
  type        = string
  default     = false
}

variable "force_destroy" {
  description = "Enable deletion of objects in bucket before destroying, locked objects or under legal hold are also deleted and not recoverable."
  type        = bool
  default     = false
}

variable "project_id" {
  description = "ID of the project the bucket is associated with. If null, ressources will be created in the default project associated with the key."
  type        = string
  default     = null
}

variable "lifecycle_rule" {
  description = "ilifecycle rules for objects in bucket."
  #type        = map(map(any))
  type        = any
  default     = {}
}

variable "website_index" {
  description = "Website Configuration."
  type        = string
  default     = null
}

variable "policy" {
  description = ""
  type        = any
  default     = null
}

