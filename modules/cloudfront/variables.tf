# Input variable for the S3 bucket domain name
variable "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  type        = string
}


# Input variable for the CloudFront origin ID
variable "origin_id" {
  description = "Unique identifier for the CloudFront origin"
  type        = string
}

# Input variable for the CloudFront distribution name
variable "distribution_name" {
  description = "Name of the CloudFront distribution"
  type        = string
}

# Input variable for the environment (e.g., dev, prod)
variable "environment" {
  description = "Environment for tagging (e.g., dev, prod)"
  type        = string
}
