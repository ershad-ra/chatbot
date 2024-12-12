resource "aws_dynamodb_table" "meetings" {
  name           = "Meetings"
  billing_mode   = "PAY_PER_REQUEST" # Correspond à On-Demand Billing

  # Définition des clés principales
  hash_key = "meetingId"

  # Définitions des attributs
  attribute {
    name = "meetingId"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  attribute {
    name = "date"
    type = "S"
  }

  # Index secondaire global
  global_secondary_index {
    name            = "StatusIndex"
    hash_key        = "status"
    range_key       = "date"
    projection_type = "ALL" # Inclure tous les attributs
  }

  # Optionnel : Activer la protection contre la suppression
  deletion_protection_enabled = false
}