variable "github_repository" {
  type = string
}
variable "name" {
  type = string
}

variable "domain" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

data "aws_caller_identity" "this" {}
locals {
  cloudfront_logs      = "${var.name}-cf-logs-${data.aws_caller_identity.this.account_id}"
  bucket_name          = "${var.name}-${data.aws_caller_identity.this.account_id}"
  bucket_regional_name = "${local.bucket_name}.s3.us-east-2.amazonaws.com"
}

