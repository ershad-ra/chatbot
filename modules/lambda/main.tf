# Lambda Function for Get Meetings
resource "aws_lambda_function" "get_meetings_function" {
  function_name = "${var.environment}-get-meetings"
  role          = var.get_meetings_execution_role_arn
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_code_hash = filebase64sha256("${path.module}/code/get_meetings.zip")
  filename         = "${path.module}/code/get_meetings.zip"

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }
}

# Lambda Function for Chatbot
resource "aws_lambda_function" "chatbot_function" {
  function_name = "${var.environment}-chatbot"
  role          = var.chatbot_execution_role_arn
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_code_hash = filebase64sha256("${path.module}/code/chatbot.zip")
  filename         = "${path.module}/code/chatbot.zip"
}

# Lambda Function for Get Pending Meetings
resource "aws_lambda_function" "get_pending_meetings_function" {
  function_name = "${var.environment}-get-pending-meetings"
  role          = var.get_pending_meetings_execution_role_arn
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_code_hash = filebase64sha256("${path.module}/code/get_pending_meetings.zip")
  filename         = "${path.module}/code/get_pending_meetings.zip"

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }
}

# Lambda Function for Change Meeting Status
resource "aws_lambda_function" "change_meeting_status_function" {
  function_name = "${var.environment}-change-meeting-status"
  role          = var.change_meeting_status_execution_role_arn
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_code_hash = filebase64sha256("${path.module}/code/change_meeting_status.zip")
  filename         = "${path.module}/code/change_meeting_status.zip"

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }
}

# Lambda Function for Create Meeting
resource "aws_lambda_function" "create_meeting_function" {
  function_name = "${var.environment}-create-meeting"
  role          = var.create_meeting_execution_role_arn
  handler       = "index.lambda_handler"
  runtime       = "python3.12"

  source_code_hash = filebase64sha256("${path.module}/code/create_meeting.zip")
  filename         = "${path.module}/code/create_meeting.zip"

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }
}



resource "aws_lambda_permission" "get_meetings_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_meetings_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/*"
}

resource "aws_lambda_permission" "get_pending_meetings_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_pending_meetings_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/*"
}

resource "aws_lambda_permission" "chatbot_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chatbot_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/*"
}

resource "aws_lambda_permission" "change_meeting_status_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.change_meeting_status_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/*"
}
