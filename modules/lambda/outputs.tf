# Outputs for Lambda Function ARNs
output "get_meetings_function_arn" {
  value = aws_lambda_function.lambda_functions["get_meetings"].arn
}

output "get_pending_meetings_function_arn" {
  value = aws_lambda_function.lambda_functions["get_pending_meetings"].arn
}

output "chatbot_function_arn" {
  value = aws_lambda_function.lambda_functions["chatbot"].arn
}

output "change_meeting_status_function_arn" {
  value = aws_lambda_function.lambda_functions["change_meeting_status"].arn
}

output "create_meeting_function_arn" {
  value = aws_lambda_function.lambda_functions["create_meeting"].arn
}
