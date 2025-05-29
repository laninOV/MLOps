resource "yandex_storage_bucket" "s3_bucket" {
  bucket     = var.bucket_name
  access_key = var.access_key
  secret_key = var.secret_key

  acl = "private"

  versioning {
    enabled = true
  }
}
