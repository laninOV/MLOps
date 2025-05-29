output "bucket_id" {
  description = "ID of the created S3 bucket"
  value       = module.s3_bucket.bucket_id
}

output "bucket_endpoint" {
  description = "Endpoint of the created S3 bucket"
  value       = module.s3_bucket.bucket_endpoint
}
