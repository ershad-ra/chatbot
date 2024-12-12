# Input variable for the S3 bucket name
variable "bucket_name" {
  description = "Name of the S3 bucket for hosting frontend files"
  type        = string
}

# Input variable for the environment (e.g., dev, prod)
variable "environment" {
  description = "Environment for tagging (e.g., dev, prod)"
  type        = string
}

# Input variable for the CloudFront distribution ARN
variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution accessing the S3 bucket"
  type        = string
}
