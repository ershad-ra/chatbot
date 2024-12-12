module "s3" {
  source                     = "./modules/s3"
  bucket_name                = var.bucket_name
  environment                = var.environment
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
}

module "cloudfront" {
  source                = "./modules/cloudfront"
  s3_bucket_domain_name = module.s3.bucket_regional_domain_name
  origin_id             = var.origin_id
  distribution_name     = var.distribution_name
  environment           = var.environment
}


# module "dynamodb" {
#   source = "./modules/dynamodb"
# }

# module "cognito" {
#   source                = "./modules/cognito"
#   user_pool_name        = var.cognito_user_pool_name
#   username              = var.username
#   user_email            = var.user_email
# }

# module "api_gateway" {
#   source = "./modules/api_gateway"
#   api_name = var.api_name
#   cognito_user_pool_arn = module.cognito.user_pool_arn
# }

# module "lambda" {
#   source = "./modules/lambda"
#   api_gateway_arn = module.api_gateway.api_arn
#   dynamodb_arn    = module.dynamodb.table_arn
# }

# module "lex" {
#   source = "./modules/lex"
# }
