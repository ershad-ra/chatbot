module "s3" {
  source       = "./modules/s3"
  bucket_name  = "frontend"
  environment  = "dev"
}


module "dynamodb" {
  source = "./modules/dynamodb"
}

module "cognito" {
  source                = "./modules/cognito"
  user_pool_name        = var.cognito_user_pool_name
  username              = var.username
  user_email            = var.user_email
}

module "api_gateway" {
  source = "./modules/api_gateway"
  api_name = var.api_name
  cognito_user_pool_arn = module.cognito.user_pool_arn
}

module "lambda" {
  source = "./modules/lambda"
  api_gateway_arn = module.api_gateway.api_arn
  dynamodb_arn    = module.dynamodb.table_arn
}

module "cloudfront" {
  source        = "./modules/cloudfront"
  s3_bucket_arn = module.s3.bucket_arn
}

module "lex" {
  source = "./modules/lex"
}
