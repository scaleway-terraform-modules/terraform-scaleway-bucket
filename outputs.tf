output "bucket_endpoint" {
  value       = scaleway_object_bucket.this.endpoint
  description = "Endpoint URL of the bucket."
}

output "bucket_id" {
  value       = scaleway_object_bucket.this.id
  description = "Unique name of the bucket."
}

output "s3_website_information" {
  value       = var.website_index != null ? scaleway_object_bucket_website_configuration.this[0] : null
  description = "S3 Website information"
}
