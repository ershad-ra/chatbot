output "website_url" {
  value = "http://${var.bucket_name}.s3-website-${data.aws_region.current.name}.amazonaws.com"
}

data "aws_region" "current" {}