provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-static-web-app"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "example" {
  bucket = aws_s3_bucket.example.id
  key    = "index.html"
  source = "path/to/index.html"
}

resource "aws_s3_bucket_object" "example_error" {
  bucket = aws_s3_bucket.example.id
  key    = "error.html"
  source = "path/to/error.html"
}

resource "aws_cloudfront_origin_access_identity" "example" {
  comment = "Access identity for my-static-web-app"
}

resource "aws_cloudfront_distribution" "example" {
  origin {
    domain_name = aws_s3_bucket.example.bucket_domain_name
    origin_id   = "S3-my-static-web-app"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.example.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id = "S3-my-static-web-app"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method = "sni-only"
  }
}

