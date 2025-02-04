locals {
  lambda_functions = {
    get_meetings          = var.get_meetings_execution_role_arn
    chatbot               = var.chatbot_execution_role_arn
    get_pending_meetings  = var.get_pending_meetings_execution_role_arn
    change_meeting_status = var.change_meeting_status_execution_role_arn
    create_meeting        = var.create_meeting_execution_role_arn
  }
}

# Create a ZIP archive for each Lambda function.
# Each archive will contain a file called "index.py" whose content is taken
# from the corresponding Python source file.
data "archive_file" "lambda_zips" {
  for_each = local.lambda_functions

  type = "zip"

  # The "source" block allows you to specify content and the filename inside the archive.
  source {
    content  = file("${path.module}/code/${each.key}.py")
    filename = "index.py"
  }

  # This writes the ZIP file to disk. The file will be named exactly like the .py file,
  # e.g. "chatbot.zip", "get_meetings.zip", etc.
  output_path = "${path.module}/code/${each.key}.zip"
}

# Lambda Function resource using the ZIP files created above.
resource "aws_lambda_function" "lambda_functions" {
  for_each = local.lambda_functions

  function_name = "${var.environment}-${each.key}"
  role          = each.value
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_code_hash = data.archive_file.lambda_zips[each.key].output_base64sha256
  filename         = data.archive_file.lambda_zips[each.key].output_path

  environment {
    variables = merge(
      {
        DYNAMODB_TABLE = var.dynamodb_table_name
      },
      each.key == "chatbot" ? {
        LEX_BOT_ID       = var.lex_bot_id,   # Pass lex_bot_id from Lex module if desired
        LEX_BOT_ALIAS_ID = "TSTALIASID"      # Hardcoded alias for testing
      } : {}
    )
  }

  depends_on = [data.archive_file.lambda_zips]
}


# Grant API Gateway permission to invoke the Lambda functions.
resource "aws_lambda_permission" "lambda_permissions" {
  for_each = aws_lambda_function.lambda_functions

  statement_id  = "AllowAPIGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
}
