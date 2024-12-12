# Create an Origin Access Control (OAC) for secure access to the S3 bucket
resource "aws_cloudfront_origin_access_control" "oac" {
  name                                    = "${var.distribution_name}-oac"
  description                             = "OAC for secure access to S3 bucket"
  origin_access_control_origin_type       = "s3"
  signing_behavior                        = "always"
  signing_protocol                        = "sigv4"
}

# Create the CloudFront Distribution
resource "aws_cloudfront_distribution" "frontend_distribution" {
  enabled = true

  # Define the S3 bucket as the origin
 origin {
  domain_name = var.s3_bucket_domain_name
  origin_id   = var.origin_id

  # Use the Origin Access Control (OAC)
  origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
}


  # Default cache behavior
  default_cache_behavior {
    target_origin_id       = var.origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # Configure custom error responses
  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/"
    error_caching_min_ttl = 0
  }

  # Default root object
  default_root_object = "index.html"

  # Price class (e.g., regions to serve content)
  price_class = "PriceClass_100"

  # Enable HTTP/2 and IPv6
  http_version   = "http2"
  is_ipv6_enabled = true

  # Use the default CloudFront certificate for HTTPS
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Add restrictions (no geographic restrictions)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = var.distribution_name
    Environment = var.environment
  }
}
