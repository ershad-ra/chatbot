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
