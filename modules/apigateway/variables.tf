# Input variables for API Gateway module

variable "api_name" {
  description = "The name of the HTTP API"
  type        = string
}

variable "api_description" {
  description = "The description of the HTTP API"
  type        = string
}

variable "cors_allow_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
}

variable "cors_allow_methods" {
  description = "List of allowed methods for CORS"
  type        = list(string)
}

variable "cors_allow_headers" {
  description = "List of allowed headers for CORS"
  type        = list(string)
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
}

# Cognito integration variables
variable "cognito_user_pool_client_id" {
  description = "The Cognito User Pool Client ID"
  type        = string
}

variable "cognito_user_pool_issuer" {
  description = "The Cognito User Pool Issuer URL"
  type        = string
}

# Lambda function ARNs
variable "lambda_function_get_meetings_arn" {
  description = "ARN of the Lambda function for GET /meetings"
  type        = string
}

variable "lambda_function_get_pending_meetings_arn" {
  description = "ARN of the Lambda function for GET /pending"
  type        = string
}

variable "lambda_function_chatbot_arn" {
  description = "ARN of the Lambda function for POST /chatbot"
  type        = string
}

variable "change_meeting_status_function_arn" {
  description = "ARN of the lambda function for changing metting status"
  type = string
}