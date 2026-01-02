# This file contain the code of creation s3 bucket.
locals {
  evironment = "dev"
  product = "dummy09"
  service = "s3withcdn"
  s3Origin = "s3"
}
# Creating Private S3 Bucket

resource "aws_s3_bucket" "this" {
  bucket = "${local.evironment}-${local.product}-${local.service}"
  force_destroy = true
  tags = {
    evironment = local.evironment
  }
}

# creating iam policy for cloudfront to access s3 objects.
data "aws_iam_policy_document" "this" {
  statement {
    sid = "AllowCloudfrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type = "service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [ "${aws_s3_bucket.this.arn}/*" ]

    condition {
      test = "GetObject"
      variable = "AWS:SourceArn"
      values = [aws_cloudfront_distribution.this.arn]
    }
  }
}

# Attach above iam policy in s3 bucket policy
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.this.json
}

# creating OAC for CDN
resource "aws_cloudfront_origin_access_control" "this" {
  name = "${local.evironment}-${local.product}-${local.service}"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

# creating cloudfront distribution for s3 bucket
resource "aws_cloudfront_distribution" "this" {
  
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id = aws_cloudfront_origin_access_control.this.id
    origin_access_control_id = local.s3Origin
  }
  
  enabled = true
  default_root_object = "index.html"
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = local.s3Origin
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    max_ttl = 86400
    default_ttl = 3600
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}
