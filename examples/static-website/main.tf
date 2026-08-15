module "bucket" {
  source = "../.."

  name = "my-static-website"
  acl  = "public-read"

  website_index          = "index.html"
  website_error_document = "error.html"

  cors_rules = [
    {
      allowed_methods = ["GET"]
      allowed_origins = ["*"]
      max_age_seconds = 3000
    }
  ]
}

output "website" {
  value       = module.bucket.s3_website_information
  description = "Website configuration, including the endpoint domain to point a DNS record to."
}
