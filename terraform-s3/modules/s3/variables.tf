variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "access_key" {
  description = "Access key for the S3 bucket"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Secret key for the S3 bucket"
  type        = string
  sensitive   = true
}
