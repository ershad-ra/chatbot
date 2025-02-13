# The name of the S3 bucket where frontend files will be hosted.
variable "bucket_name" {
  description = "Name of the S3 bucket for hosting frontend files"
  type        = string
}

# The regional domain name of the S3 bucket, used by CloudFront as the origin for the distribution.
variable "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  type        = string
}

# A unique identifier for the CloudFront origin, required to link the S3 bucket with CloudFront.
variable "origin_id" {
  description = "Unique identifier for the CloudFront origin"
  type        = string
}

# The name of the CloudFront distribution that serves the frontend files via the S3 bucket.
variable "distribution_name" {
  description = "Name of the CloudFront distribution"
  type        = string
}

# The name of the Cognito User Pool, which manages user authentication for the application.
variable "user_pool_name" {
  description = "The name of the Cognito User Pool"
  type        = string
}

# The username of the initial user created in the Cognito User Pool.
variable "username" {
  description = "The username for the initial Cognito user"
  type        = string
}

# The email address of the initial user created in the Cognito User Pool.
variable "user_email" {
  description = "The email address for the initial Cognito user"
  type        = string
}

# The environment tag for the resources, used to distinguish between environments like dev and prod.
variable "environment" {
  description = "The environment for tagging resources"
  type        = string
}

# AWS Region
variable "region" {
  description = "The AWS region for resources"
  type        = string
}

variable "lex_bot_name" {
  description = "Name of the Lex bot"
  type        = string
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