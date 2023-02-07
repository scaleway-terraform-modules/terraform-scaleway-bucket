output "bucket_endpoint" {
  value       = scaleway_object_bucket.this.endpoint
  description = "Endpoint URL of the bucket."
}

output "bucket_id" {
  value       = scaleway_object_bucket.this.id
  description = "Unique name of the bucket."
}
