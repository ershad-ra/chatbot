# Outputs for Lambda Function ARNs
output "get_meetings_function_arn" {
  description = "ARN of the Lambda function for GET /meetings"
  value       = aws_lambda_function.get_meetings_function.arn
}

output "get_pending_meetings_function_arn" {
  description = "ARN of the Lambda function for GET /pending"
  value       = aws_lambda_function.get_pending_meetings_function.arn
}

output "chatbot_function_arn" {
  description = "ARN of the Lambda function for POST /chatbot"
  value       = aws_lambda_function.chatbot_function.arn
}

output "change_meeting_status_function_arn" {
  description = "ARN of the Lambda function for PUT /status"
  value       = aws_lambda_function.change_meeting_status_function.arn
}

output "create_meeting_function_arn" {
  description = "ARN of the Lambda function for POST /meetings"
  value       = aws_lambda_function.create_meeting_function.arn
}
