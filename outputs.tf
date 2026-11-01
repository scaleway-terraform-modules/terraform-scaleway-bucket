output "bucket_endpoint" {
  description = "Endpoint URL of the bucket."
  value       = scaleway_object_bucket.this.endpoint
}

output "bucket_id" {
  description = "Regional ID of the bucket (`{region}/{name}`)."
  value       = scaleway_object_bucket.this.id
}

output "bucket_name" {
  description = "Name of the bucket."
  value       = scaleway_object_bucket.this.name
}

output "bucket_region" {
  description = "Region of the bucket."
  value       = scaleway_object_bucket.this.region
}

output "bucket_s3_url" {
  description = "S3 URL of the bucket (`s3://{name}`), as used by S3 tools together with the regional S3 API endpoint."
  value       = "s3://${scaleway_object_bucket.this.name}"
}

output "s3_website_information" {
  description = "S3 Website information"
  value       = var.website_index != null ? scaleway_object_bucket_website_configuration.this[0] : null
}

output "server_side_encryption" {
  description = "Server-side encryption configuration of the bucket."
  value       = var.sse_algorithm != null ? scaleway_object_bucket_server_side_encryption_configuration.this[0] : null
}
