resource "minio_s3_bucket" "buckets" {
  for_each = length(var.buckets) > 0 ? var.buckets : [var.name]
  bucket = each.key
  acl    = "private"
}

locals {
  bucket_arns = join("\",\"", setunion(flatten([for item in minio_s3_bucket.buckets: [item.arn, "${item.arn}/*"]])))
}

resource "minio_ilm_policy" "expire" {
  for_each = minio_s3_bucket.buckets
  bucket = each.value.bucket
  rule {
    id         = "expire"
    expiration = var.expiration
  }
}

resource "minio_iam_user" "user" {
  name = "${var.name}-user"
}

resource "minio_iam_policy" "policy" {
  name   = "${var.name}-policy"
  policy = <<-EOF
    {
      "Version":"2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "s3:DeleteObject",
            "s3:DeleteObjectVersion",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:PutObject",
            "s3:ListBucket"
          ],
          "Resource": ["${local.bucket_arns}"]
        }
      ]
    }
    EOF
}

resource "minio_iam_user_policy_attachment" "attachment" {
  user_name   = minio_iam_user.user.id
  policy_name = minio_iam_policy.policy.id
}

resource "minio_iam_service_account" "user" {
  target_user = minio_iam_user.user.name
}