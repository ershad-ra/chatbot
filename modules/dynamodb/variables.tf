variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "billing_mode" {
  description = "The billing mode of the DynamoDB table (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "The primary key (partition key) for the DynamoDB table"
  type        = string
}

variable "attributes" {
  description = "A list of attributes with their types for the DynamoDB table"
  type = list(object({
    name = string
    type = string
  }))
}

variable "global_secondary_indexes" {
  description = "A list of global secondary indexes for the DynamoDB table"
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = string
    projection_type = string
  }))
  default = []
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection for the DynamoDB table"
  type        = bool
  default     = false
}