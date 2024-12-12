variable "bucket_name" {
  description = "Name of the S3 bucket."
  type        = string
}

variable "environment" {
  description = "Environment tag for the S3 bucket (e.g., dev, prod)."
  type        = string
  default     = "dev"
}
