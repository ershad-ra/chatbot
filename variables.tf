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

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "Meetings"
}

variable "dynamodb_attributes" {
  description = "A list of attributes for the DynamoDB table"
  type = list(object({
    name = string
    type = string
  }))
  default = [
    { name = "meetingId", type = "S" },
    { name = "status", type = "S" },
    { name = "date", type = "S" }
  ]
}

variable "dynamodb_global_secondary_indexes" {
  description = "A list of global secondary indexes for the DynamoDB table"
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = string
    projection_type = string
  }))
  default = [
    {
      name            = "StatusIndex"
      hash_key        = "status"
      range_key       = "date"
      projection_type = "ALL"
    }
  ]
}