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


module "apigateway" {
  source                           = "./modules/apigateway"
  api_name                         = "chatbot-api"
  api_description                  = "API for Chatbot Application"
  cors_allow_origins               = ["*"]
  cors_allow_methods               = ["GET", "POST", "PUT", "DELETE"]
  cors_allow_headers               = ["*"]
  stage_name                       = "dev"
  cognito_user_pool_client_id      = module.cognito.user_pool_client_id
  cognito_user_pool_issuer         = "https://cognito-idp.${var.region}.amazonaws.com/${module.cognito.user_pool_id}"
  lambda_function_get_meetings_arn = module.lambda.get_meetings_function_arn
  lambda_function_get_pending_meetings_arn = module.lambda.get_pending_meetings_function_arn
  lambda_function_chatbot_arn      = module.lambda.chatbot_function_arn
  change_meeting_status_function_arn = module.lambda.change_meeting_status_function_arn

}


module "cognito" {
  source                       = "./modules/cognito"
  user_pool_name               = var.user_pool_name
  username                     = var.username
  user_email                   = var.user_email
  environment                  = var.environment
  api_id                       = module.apigateway.api_id # Pass API Gateway ID
  region                       = var.region # Pass AWS region
}

module "lambda" {
  source               = "./modules/lambda"
  environment          = var.environment
  dynamodb_table_name  = module.dynamodb.table_name
  dynamodb_table_arn   = module.dynamodb.table_arn
  get_meetings_execution_role_arn = module.iam.get_meetings_execution_role_arn
  chatbot_execution_role_arn = module.iam.chatbot_execution_role_arn
  get_pending_meetings_execution_role_arn = module.iam.get_pending_meetings_execution_role_arn
  change_meeting_status_execution_role_arn = module.iam.change_meeting_status_execution_role_arn
  create_meeting_execution_role_arn = module.iam.create_meeting_execution_role_arn
  api_gateway_execution_arn = module.apigateway.execution_arn
  lex_bot_id      = module.lex.lex_bot_id
}


module "dynamodb" {
  source      = "./modules/dynamodb"
  table_name  = "Meetings"
  environment = var.environment
}

module "iam" {
  source = "./modules/iam"
  environment = var.environment
  dynamodb_table_arn   = module.dynamodb.table_arn
}

module "lex" {
  source      = "./modules/lex"
  environment = var.environment
  lex_bot_name = "MeetyBot"
}

# Exécution automatique du script après la création des ressources
resource "null_resource" "frontend_setup" {
  provisioner "local-exec" {
    command = "bash ./modules/website/setup_frontend.sh"
  }

  depends_on = [module.s3, module.cognito, module.apigateway]
}
