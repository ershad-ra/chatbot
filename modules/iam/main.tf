# IAM Role for Lambda Execution (Get Meetings)
resource "aws_iam_role" "get_meetings_execution_role" {
  name = "${var.environment}-get-meetings-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for DynamoDB Read Access (Get Meetings)
resource "aws_iam_policy" "dynamodb_read_policy_get_meetings" {
  name        = "${var.environment}-dynamodb-read-get-meetings"
  description = "IAM policy for reading from DynamoDB for Get Meetings Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["dynamodb:GetItem", "dynamodb:Query"]
        Resource = [var.dynamodb_table_arn, "${var.dynamodb_table_arn}/index/StatusIndex"]
      }
    ]
  })
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_dynamodb_read_policy_get_meetings" {
  role       = aws_iam_role.get_meetings_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_read_policy_get_meetings.arn
}

# IAM Role for Lambda Execution (Chatbot)
resource "aws_iam_role" "chatbot_execution_role" {
  name = "${var.environment}-chatbot-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Lex Access (Chatbot)
resource "aws_iam_policy" "lex_access_policy_chatbot" {
  name        = "${var.environment}-lex-access-policy-chatbot"
  description = "IAM policy for accessing Lex for Chatbot Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["lex:PostText", "lex:RecognizeText"]
        Resource = "*"
      }
    ]
  })
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_lex_access_policy_chatbot" {
  role       = aws_iam_role.chatbot_execution_role.name
  policy_arn = aws_iam_policy.lex_access_policy_chatbot.arn
}

# IAM Role for Lambda Execution (Get Pending Meetings)
resource "aws_iam_role" "get_pending_meetings_execution_role" {
  name = "${var.environment}-get-pending-meetings-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for DynamoDB Read Access (Get Pending Meetings)
resource "aws_iam_policy" "dynamodb_read_policy_get_pending_meetings" {
  name        = "${var.environment}-dynamodb-read-get-pending-meetings"
  description = "IAM policy for reading from DynamoDB for Get Pending Meetings Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["dynamodb:GetItem", "dynamodb:Query"]
        Resource = [var.dynamodb_table_arn, "${var.dynamodb_table_arn}/index/StatusIndex"]
      }
    ]
  })
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_dynamodb_read_policy_get_pending_meetings" {
  role       = aws_iam_role.get_pending_meetings_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_read_policy_get_pending_meetings.arn
}

# IAM Role for Lambda Execution (Change Meeting Status)
resource "aws_iam_role" "change_meeting_status_execution_role" {
  name = "${var.environment}-change-meeting-status-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for DynamoDB Update Access (Change Meeting Status)
resource "aws_iam_policy" "dynamodb_update_policy_change_meeting_status" {
  name        = "${var.environment}-dynamodb-update-change-meeting-status"
  description = "IAM policy for updating DynamoDB for Change Meeting Status Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["dynamodb:UpdateItem", "dynamodb:DescribeTable"]
        Resource = [var.dynamodb_table_arn]
      }
    ]
  })
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_dynamodb_update_policy_change_meeting_status" {
  role       = aws_iam_role.change_meeting_status_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_update_policy_change_meeting_status.arn
}

# IAM Role for Lambda Execution (Create Meeting)
resource "aws_iam_role" "create_meeting_execution_role" {
  name = "${var.environment}-create-meeting-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for DynamoDB Write Access (Create Meeting)
resource "aws_iam_policy" "dynamodb_write_policy_create_meeting" {
  name        = "${var.environment}-dynamodb-write-create-meeting"
  description = "IAM policy for writing to DynamoDB for Create Meeting Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["dynamodb:PutItem", "dynamodb:DescribeTable"]
        Resource = [var.dynamodb_table_arn]
      }
    ]
  })
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_dynamodb_write_policy_create_meeting" {
  role       = aws_iam_role.create_meeting_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_write_policy_create_meeting.arn
}


