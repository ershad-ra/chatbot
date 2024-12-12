output "table_name" {
  description = "The name of the DynamoDB table"
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = aws_dynamodb_table.this.arn
}

output "global_secondary_index_names" {
  description = "The names of the global secondary indexes"
  value = [
    for index in aws_dynamodb_table.this.global_secondary_index : index.name
  ]
}