  # Create the user pool
resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

  # Configure auto-verified attributes
  auto_verified_attributes = ["email"]

  # Configure password policies
  password_policy {
    minimum_length    = 6
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }

  # MFA configuration (disabled in this setup)
  mfa_configuration = "OFF"

  # Account recovery settings
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  # Admin user creation settings
admin_create_user_config {
  allow_admin_create_user_only = true
  invite_message_template {
    email_message = "Hello {username}, welcome to the Chatbot Application.\nYour temporary password is {####}"
    email_subject = "Welcome to Chatbot!"
    sms_message   = "Hello {username}, your temporary password is {####}. Welcome to Chatbot!"
  }
}


  # Email configuration
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # Define the user pool schema
  schema {
    name               = "email"
    attribute_data_type = "String"
    required           = true
    mutable            = true
  }

  tags = {
    Environment = var.environment
    Name        = var.user_pool_name
  }
}

# Create a Cognito User Pool Client
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "user-pool-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  # Enable USER_PASSWORD_AUTH flow
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  # Do not generate a client secret
  generate_secret = false
}

# Create a Cognito User
resource "aws_cognito_user" "user" {
  user_pool_id = aws_cognito_user_pool.user_pool.id

  username = var.username

  attributes = {
    email = var.user_email
  }

  # Set delivery medium
  desired_delivery_mediums = ["EMAIL"]
}

# # JWT Authorizer for API Gateway
# resource "aws_apigatewayv2_authorizer" "jwt_authorizer" {
#   api_id        = var.api_id # Pass API Gateway ID
#   authorizer_type = "JWT"
#   name          = "CognitoJWTAuthorizer"

#   identity_sources = ["$request.header.Authorization"]

#   jwt_configuration {
#     audience = [aws_cognito_user_pool_client.user_pool_client.id]
#     issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
#   }
# }
