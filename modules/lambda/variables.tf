variable "environment" {
  description = "The environment for tagging (e.g., dev, prod)"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  type        = string
}

variable "get_meetings_execution_role_arn" {
  description = "value"
  type = string
  
}

variable "chatbot_execution_role_arn" {
  description = "IAM Role ARN for the Chatbot Lambda function"
  type        = string
}

variable "get_pending_meetings_execution_role_arn" {
  description = "value"
  type = string
}

variable "change_meeting_status_execution_role_arn" {
  description = "value"
  type = string
}

variable "create_meeting_execution_role_arn" {
  description = "value"
  type = string
}

variable "api_gateway_execution_arn" {
  description = "Execution ARN of the API Gateway"
  type        = string
}


variable "lex_bot_id" {
  description = "The Lex Bot ID"
  type        = string
}