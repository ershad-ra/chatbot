variable "bucket_name" {
  description = "Name of the S3 bucket for hosting frontend files"
  type        = string
  default     = "frontend-ershad-test"
}

variable "environment" {
  description = "Environment for tagging (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  type        = string
  default     = "frontend-ershad-test.s3.amazonaws.com"
}

variable "origin_id" {
  description = "Unique identifier for the CloudFront origin"
  type        = string
  default     = "frontend-ershad-test-origin"
}

variable "distribution_name" {
  description = "Name of the CloudFront distribution"
  type        = string
  default     = "frontend-ershad-test-distribution"
}
