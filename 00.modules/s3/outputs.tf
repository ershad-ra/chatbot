output "bucket_name" {
  description = "The name of the S3 bucket."
  value       = aws_s3_bucket.bucket.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.bucket.arn
}

output "oai_id" {
  description = "The ID of the CloudFront Origin Access Identity."
  value       = aws_cloudfront_origin_access_identity.oai.id
}
