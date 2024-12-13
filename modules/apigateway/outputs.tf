# Output the API Gateway HTTP API ID
output "api_id" {
  description = "The ID of the HTTP API Gateway"
  value       = aws_apigatewayv2_api.http_api.id
}

# Output the API Gateway stage name
output "stage_name" {
  description = "The name of the API Gateway stage"
  value       = aws_apigatewayv2_stage.http_api_stage.name
}

# Output the base URL of the API Gateway
output "api_base_url" {
  description = "The base URL of the API Gateway"
  value       = aws_apigatewayv2_stage.http_api_stage.invoke_url
}
