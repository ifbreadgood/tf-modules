data "aws_canonical_user_id" "current" {}
data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront" {}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"

  domain_name = var.domain
  zone_id     = var.hosted_zone_id

  validation_method = "DNS"

  wait_for_validation = true

  providers = {
    aws = aws.acm
  }
}

module "cloudfront_logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.2.2"

  create_bucket = true
  bucket        = local.cloudfront_logs

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  grant = [
    {
      type       = "CanonicalUser"
      permission = "FULL_CONTROL"
      id         = data.aws_canonical_user_id.current.id
    },
    {
      type       = "CanonicalUser"
      permission = "FULL_CONTROL"
      id         = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id
    }
  ]
  force_destroy = true

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

}

module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "3.4.1"

  aliases = [var.domain]

  comment             = "${var.domain} cdn"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_control = true
  origin_access_control = {
    (var.name) = {
      description      = "${var.name} origin access control"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  logging_config = {
    bucket = module.cloudfront_logs.s3_bucket_bucket_domain_name
  }

  origin = {
    (var.domain) = {
      domain_name           = local.bucket_regional_name
      origin_access_control = var.name
    }
  }

  default_cache_behavior = {
    target_origin_id       = var.domain
    viewer_protocol_policy = "redirect-to-https"

    compress     = true
    query_string = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "*"
      target_origin_id       = var.domain
      viewer_protocol_policy = "redirect-to-https"

      compress     = true
      query_string = true
    }
  ]

  custom_error_response = [
    {
      error_code            = 404
      error_caching_min_ttl = 10
      response_code         = 200
      response_page_path    = "/index.html"
    },
    {
      error_code            = 403
      error_caching_min_ttl = 10
      response_code         = 200
      response_page_path    = "/index.html"
    }
  ]

  viewer_certificate = {
    acm_certificate_arn      = module.acm.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_route53_record" "r53_record" {
  zone_id = var.hosted_zone_id
  alias {
    name                   = module.cdn.cloudfront_distribution_domain_name
    zone_id                = module.cdn.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = true
  }
  name = var.domain
  type = "A"
}

