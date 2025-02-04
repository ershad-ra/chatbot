output "lex_bot_id" {
  description = "The ID of the Amazon Lex V2 bot"
  value       = aws_lexv2models_bot.meety_bot.id
}

output "lex_runtime_role_arn" {
  description = "The ARN of the Lex runtime role"
  value       = aws_iam_role.lex_runtime_role.arn
}