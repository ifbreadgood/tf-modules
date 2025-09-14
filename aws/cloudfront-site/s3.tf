module "site_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.2.2"

  create_bucket = true
  bucket        = local.bucket_name

  attach_policy = true

  policy = <<-EOT
      {
        "Version": "2012-10-17",
        "Id": "PolicyForCloudFrontPrivateContent",
        "Statement": [
            {
                "Sid": "AllowCloudFrontServicePrincipal",
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudfront.amazonaws.com"
                },
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::${local.bucket_name}/*",
                "Condition": {
                    "StringEquals": {
                      "AWS:SourceArn": "${module.cdn.cloudfront_distribution_arn}"
                    }
                }
            }
        ]
      }
      EOT

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  force_destroy = true
}

