output "api_gateway_url" {
  value = module.api_gateway.api_url
}

output "cognito_user_pool_id" {
  value = module.cognito.user_pool_id
}

output "cloudfront_url" {
  value = module.cloudfront.url
}
