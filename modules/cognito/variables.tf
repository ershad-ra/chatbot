# Input variable for the user pool name
variable "user_pool_name" {
  description = "The name of the Cognito User Pool"
  type        = string
}

# Input variable for the username
variable "username" {
  description = "The username for the initial Cognito user"
  type        = string
}

# Input variable for the user email
variable "user_email" {
  description = "The email address for the initial Cognito user"
  type        = string
}

# Input variable for the environment (e.g., dev, prod)
variable "environment" {
  description = "Environment for tagging (e.g., dev, prod)"
  type        = string
}

variable "api_id" {
  description = "The ID of the API Gateway to which the JWT Authorizer is attached"
  type        = string
}

variable "region" {
  description = "The AWS region where the Cognito resources are deployed"
  type        = string
}