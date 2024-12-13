# Input Variables for DynamoDB Module

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "environment" {
  description = "The environment for tagging (e.g., dev, prod)"
  type        = string
}
