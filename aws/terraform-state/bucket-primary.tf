data "aws_caller_identity" "current" {}
resource "aws_s3_bucket" "primary" {
  bucket = "${var.name}-${data.aws_caller_identity.current.account_id}-primary"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "primary" {
  bucket = aws_s3_bucket.primary.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "primary" {
  bucket = aws_s3_bucket.primary.id

  versioning_configuration {
    status = "Enabled"
  }
}

# data "aws_iam_policy_document" "primary" {
#   statement {
#     actions = [
#       "s3:DeleteBucket",
#       "s3:DeleteObject",
#       "s3:DeleteObjectVersion",
#     ]
#     resources = [
#       aws_s3_bucket.primary.arn,
#       "${aws_s3_bucket.primary.arn}/*",
#     ]
#     principals {
#       type = "AWS"
#       identifiers = [
#         "*",
#       ]
#     }
#     effect = "Deny"
#   }
# }
#
# resource "aws_s3_bucket_policy" "primary" {
#   bucket = aws_s3_bucket.primary.id
#   policy = data.aws_iam_policy_document.primary.json
# }