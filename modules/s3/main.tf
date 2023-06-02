
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "custodian_state" {
  bucket = "custodian-${var.org_name}-state"
}

resource "aws_s3_bucket" "custodian_policies" {
  bucket = "custodian-${var.org_name}-policies"
}

resource "aws_s3_bucket" "custodian_logs" {
  bucket        = "custodian-${var.org_name}-logs"
  force_destroy = true
}

resource "aws_s3_bucket" "cloudtrial_logs" {
  bucket        = "cloudtrail-${var.org_name}-logs"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "custodian_state_acl" {
  bucket = aws_s3_bucket.custodian_state.id
  acl    = "private"
}

resource "aws_s3_bucket_acl" "custodian_policies_acl" {
  bucket = aws_s3_bucket.custodian_policies.id
  acl    = "private"
}

resource "aws_s3_bucket_acl" "custodian_logs_acl" {
  bucket = aws_s3_bucket.custodian_logs.id
  acl    = "private"

}

resource "aws_s3_bucket_acl" "cloudtrial_logs_acl" {
  bucket = aws_s3_bucket.cloudtrial_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrial_logs.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.cloudtrial_logs.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.cloudtrial_logs.arn}/cloudtrail/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_object" "custodian_policies_files" {
  for_each = fileset("./policies/", "**")
  bucket   = aws_s3_bucket.custodian_policies.id
  key      = each.value
  source   = "./policies/${each.value}"
  etag     = filemd5("./policies/${each.value}")
}