variable "environment" {
  description = "Environment for the Lex module (e.g., dev, prod)"
  type        = string
}

variable "lex_bot_name" {
  description = "Name of the Amazon Lex V2 bot"
  type        = string
}
