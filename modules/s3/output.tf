output "cloudtrail_bucket" {
  value = aws_s3_bucket.cloudtrial_logs.id
}
