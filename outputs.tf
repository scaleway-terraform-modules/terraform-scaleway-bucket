output "bucket_endpoint" {
  value       = scaleway_object_bucket.this.endpoint
  description = "Endpoint URL of the bucket."
}

output "bucket_id" {
  value       = scaleway_object_bucket.this.id
  description = "Regional ID of the bucket (`{region}/{name}`)."
}

output "bucket_name" {
  value       = scaleway_object_bucket.this.name
  description = "Name of the bucket."
}

output "bucket_region" {
  value       = scaleway_object_bucket.this.region
  description = "Region of the bucket."
}

output "s3_website_information" {
  value       = var.website_index != null ? scaleway_object_bucket_website_configuration.this[0] : null
  description = "S3 Website information"
}

output "server_side_encryption" {
  value       = var.sse_algorithm != null ? scaleway_object_bucket_server_side_encryption_configuration.this[0] : null
  description = "Server-side encryption configuration of the bucket."
}
