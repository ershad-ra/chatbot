# terraform {
#   backend "s3" {
#     bucket         = "ershad-remi-tf-state-do-not-delete"           # S3 bucket name
#     key            = "state/terraform.tfstate"                      # Path to store the state file in the bucket
#     region         = "eu-west-1"                                    # AWS region where the bucket is located
#     encrypt        = true                                           # Enable server-side encryption for the state file
#     dynamodb_table = "chatbot-lock-table"                           # (Optional) DynamoDB table for state locking
#   }
# }

# resource "aws_dynamodb_table" "state_lock" {
#   name         = "chatbot-lock-table"
#   billing_mode = "PAY_PER_REQUEST"

#   # Define the partition key
#   hash_key = "LockID"

#   # Attribute schema
#   attribute {
#     name = "LockID"
#     type = "S" # String type
#   }

#   tags = {
#     Name        = "chatbot-lock-table"
#     Environment = "dev"
#   }
# }


