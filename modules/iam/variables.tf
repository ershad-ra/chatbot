variable "environment" {
  description = "The environment for tagging (e.g., dev, prod)"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  type        = string
}