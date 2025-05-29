variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "zone" {
  description = "Yandex Cloud availability zone"
  type        = string
  default     = "ru-central1-a"
}

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
