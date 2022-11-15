
resource "aws_cloudwatch_log_group" "cloudtrial_log_group" {
  name = "cloudtrial-log-group"
}

resource "aws_cloudtrail" "global_cloudtrail" {
  
  name                          = "global_${var.org_name}_cloudtrail"
  s3_bucket_name                = var.cloudtrail_bucket
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  enable_log_file_validation    = true
  enable_logging                = true
  is_multi_region_trail         = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrial_log_group.arn}:*"
  cloud_watch_logs_role_arn     = var.cloudtrail_role
}

# TODO: Add KMS