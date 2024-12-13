output "get_meetings_execution_role_arn" {
  description = "value"
  value = aws_iam_role.get_meetings_execution_role.arn
}

output "chatbot_execution_role_arn" {
  description = "value"
  value = aws_iam_role.chatbot_execution_role.arn
}

output "get_pending_meetings_execution_role_arn" {
  description = "value"
  value = aws_iam_role.get_pending_meetings_execution_role.arn
}

output "change_meeting_status_execution_role_arn" {
  description = "value"
  value = aws_iam_role.change_meeting_status_execution_role.arn
}

output "create_meeting_execution_role_arn" {
  description = "value"
  value = aws_iam_role.create_meeting_execution_role.arn
}