# --- storage/main.tf ---

resource "aws_s3_bucket" "storage_bucket" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}