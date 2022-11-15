variable "cloudtrail_bucket" {
  type = string
  description = "bucket for cloudtrial logs"
}

variable "cloudtrail_role" {
  type = string
  description = "role for cloudtrial's cloudwatch log group"
}

variable "org_name" {
  type = string
}