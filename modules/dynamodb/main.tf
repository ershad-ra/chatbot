# Create DynamoDB Table for Meetings
resource "aws_dynamodb_table" "meetings" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST" # Matches CloudFormation's PAY_PER_REQUEST mode
  hash_key       = "meetingId"

  attribute {
    name = "meetingId"
    type = "S"
  }

  # Add attributes for the Global Secondary Index (GSI)
  attribute {
    name = "status"
    type = "S"
  }

  attribute {
    name = "date"
    type = "S"
  }

  # Define the Global Secondary Index
  global_secondary_index {
    name            = "StatusIndex"
    hash_key        = "status"
    range_key       = "date"
    projection_type = "ALL"
  }

  tags = {
    Environment = var.environment
    Name        = var.table_name
  }
}
