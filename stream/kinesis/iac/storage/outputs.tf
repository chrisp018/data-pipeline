# --- storage/outputs.tf ---

output "bucket_arn" {
  value = aws_s3_bucket.storage_bucket.arn
}