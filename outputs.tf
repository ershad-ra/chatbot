output "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  value       = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = module.dynamodb.table_arn
}

output "dynamodb_global_secondary_index_names" {
  description = "The names of the global secondary indexes"
  value       = module.dynamodb.global_secondary_index_names
}