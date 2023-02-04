variable "force_destroy" {
  description = "Enable deletion of objects in bucket before destroying, locked objects or under legal hold are also deleted and not recoverable."
  type        = bool
  default     = false
}

variable "name" {
  description = "Name of the bucket."
  type        = string
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
