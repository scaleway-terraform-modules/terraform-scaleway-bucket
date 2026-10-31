variable "user_id" {
  description = "ID of the Scaleway user granted full access to the bucket, e.g. your own user ID."
  type        = string
}

locals {
  bucket_name = "my-bucket-with-policy"
}

module "bucket" {
  source = "../.."

  name = local.bucket_name

  policy = {
    Version = "2023-04-17"
    Id      = "my-bucket-policy"
    Statement = [
      {
        # A bucket policy replaces the default access: keep a statement granting
        # yourself access, or you may lock yourself out of the bucket.
        Sid       = "AllowUserFullAccess"
        Effect    = "Allow"
        Principal = { SCW = "user_id:${var.user_id}" }
        Action    = ["s3:*"]
        Resource  = [local.bucket_name, "${local.bucket_name}/*"]
      },
      {
        # Use { SCW = "*" } rather than "*": all principals in the list must have
        # the same type for Terraform to accept the policy.
        Sid       = "AllowPublicRead"
        Effect    = "Allow"
        Principal = { SCW = "*" }
        Action    = ["s3:GetObject"]
        Resource  = ["${local.bucket_name}/*"]
      }
    ]
  }
}
