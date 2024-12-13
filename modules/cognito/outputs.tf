# Output the Cognito User Pool ID
output "user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.user_pool.id
}

# Output the Cognito User Pool Client ID
output "user_pool_client_id" {
  description = "The client ID for the Cognito User Pool app client"
  value       = aws_cognito_user_pool_client.user_pool_client.id
}

# # Output the JWT Authorizer ID
# output "jwt_authorizer_id" {
#   description = "The ID of the JWT Authorizer for API Gateway"
#   value       = aws_apigatewayv2_authorizer.jwt_authorizer.id
# }