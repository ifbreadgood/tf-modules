resource "aws_s3_bucket" "backup" {
  bucket   = "${var.name}-${data.aws_caller_identity.current.account_id}-backup"
  provider = aws.backup
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup" {
  bucket = aws_s3_bucket.backup.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
  provider = aws.backup
}

resource "aws_s3_bucket_versioning" "backup" {
  bucket = aws_s3_bucket.backup.id

  versioning_configuration {
    status = "Enabled"
  }
  provider = aws.backup
}

# data "aws_iam_policy_document" "backup" {
#   statement {
#     actions = [
#       "s3:DeleteBucket",
#       "s3:DeleteObject",
#       "s3:DeleteObjectVersion",
#     ]
#     resources = [
#       aws_s3_bucket.backup.arn,
#       "${aws_s3_bucket.backup.arn}/*",
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
# resource "aws_s3_bucket_policy" "backup" {
#   bucket   = aws_s3_bucket.backup.id
#   policy = data.aws_iam_policy_document.backup.json
#   provider = aws.backup
# }