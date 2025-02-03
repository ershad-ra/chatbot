# Create an API Gateway HTTP API
resource "aws_apigatewayv2_api" "http_api" {
  name          = var.api_name
  protocol_type = "HTTP"
  description   = var.api_description

  cors_configuration {
    allow_origins = var.cors_allow_origins
    allow_methods = var.cors_allow_methods
    allow_headers = var.cors_allow_headers
  }
}

# Create an API Gateway Stage
resource "aws_apigatewayv2_stage" "http_api_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = var.stage_name
  auto_deploy = true
}

# Attach JWT Authorizer to API Gateway
resource "aws_apigatewayv2_authorizer" "jwt_authorizer" {
  api_id        = aws_apigatewayv2_api.http_api.id
  authorizer_type = "JWT"
  name          = "CognitoJWTAuthorizer"

  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [var.cognito_user_pool_client_id]
    issuer   = var.cognito_user_pool_issuer
  }
}

# Example Route: Get Meetings
resource "aws_apigatewayv2_route" "get_meetings_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /meetings"
  target    = "integrations/${aws_apigatewayv2_integration.get_meetings_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt_authorizer.id
}

# Example Integration: Get Meetings
resource "aws_apigatewayv2_integration" "get_meetings_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.lambda_function_get_meetings_arn
  payload_format_version = "2.0"
}

# Example Route: Get Pending Meetings
resource "aws_apigatewayv2_route" "get_pending_meetings_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /pending"
  target    = "integrations/${aws_apigatewayv2_integration.get_pending_meetings_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt_authorizer.id
}

# Example Integration: Get Pending Meetings
resource "aws_apigatewayv2_integration" "get_pending_meetings_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.lambda_function_get_pending_meetings_arn
  payload_format_version = "2.0"
}

# Example Route: Chatbot
resource "aws_apigatewayv2_route" "chatbot_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /chatbot"
  target    = "integrations/${aws_apigatewayv2_integration.chatbot_integration.id}"
}

# Example Integration: Chatbot
resource "aws_apigatewayv2_integration" "chatbot_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.lambda_function_chatbot_arn
  payload_format_version = "2.0"
}


# Example Route: Change Meeting Status
resource "aws_apigatewayv2_route" "put_status_route" {
  api_id     = aws_apigatewayv2_api.http_api.id
  route_key  = "PUT /status"
  target     = "integrations/${aws_apigatewayv2_integration.change_meeting_status_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt_authorizer.id
}


# Example Integration: Change Meeting Status
resource "aws_apigatewayv2_integration" "change_meeting_status_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.change_meeting_status_function_arn
  payload_format_version = "2.0"
}