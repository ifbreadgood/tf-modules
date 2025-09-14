module "iam_github_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  version = "5.48.0"
}

module "github_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.48.0"

  name = var.name
  path = "/"

  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "s3:PutObject",
          "Resource": "${module.site_bucket.s3_bucket_arn}/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "${module.site_bucket.s3_bucket_arn}"
        }
      ]
    }
    EOF
}

module "iam_github_oidc_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "5.48.0"

  name     = var.name
  subjects = ["${var.github_repository}:*"]

  policies = {
    bucketSite = module.github_iam_policy.arn
  }
}
