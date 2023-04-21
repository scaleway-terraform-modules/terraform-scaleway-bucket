output "bucket_endpoint" {
  value       = scaleway_object_bucket.main.endpoint
  description = "Endpoint URL of the bucket."
}

output "bucket_id" {
  value       = scaleway_object_bucket.main.id
  description = "Unique name of the bucket."
}
