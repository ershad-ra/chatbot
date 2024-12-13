# IAM Role for Lex Runtime
resource "aws_iam_role" "lex_runtime_role" {
  name = "${var.environment}-lex-runtime-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lexv2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lex_runtime_policy" {
  name        = "${var.environment}-lex-runtime-policy"
  description = "IAM policy for Amazon Lex runtime role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "polly:SynthesizeSpeech",
          "comprehend:DetectSentiment"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lex_runtime_policy" {
  role       = aws_iam_role.lex_runtime_role.name
  policy_arn = aws_iam_policy.lex_runtime_policy.arn
}

# Define Lex Bot
resource "aws_lexv2models_bot" "meety_bot" {
  name                   = var.lex_bot_name
  description            = "Amazon Lex V2 Bot for Chatbot"
  role_arn               = aws_iam_role.lex_runtime_role.arn
  idle_session_ttl_in_seconds = 300

  data_privacy {
    child_directed = false
  }
}

# Define Locale for the Bot
resource "aws_lexv2models_bot_locale" "en_us_locale" {
  bot_id                 = aws_lexv2models_bot.meety_bot.id
  locale_id              = "en_US"
  description            = "English locale for the bot"
  n_lu_intent_confidence_threshold = 0.7
  bot_version = "DRAFT"
  voice_settings {
    voice_id = "Ivy"
    engine = "standard"
  }
}

# Define Intent for Start Meety
resource "aws_lexv2models_intent" "start_meety" {
  bot_id                 = aws_lexv2models_bot.meety_bot.id
  bot_version            = aws_lexv2models_bot_locale.en_us_locale.bot_version
  name                   = "StartMeety"
  description            = "Welcome intent"
  locale_id              = aws_lexv2models_bot_locale.en_us_locale.locale_id

  # Provide each utterance as a separate block
  sample_utterance {
    utterance = "Hello"
  }

  sample_utterance {
    utterance = "Hey Meety"
  }

  sample_utterance {
    utterance = "I need your help"
  }

  closing_setting {
    active = true
    closing_response {
      message_group {
        message {
          plain_text_message {
            value = "Hey, I'm meety, the chatbot to help scheduling meetings. How can I help you?"
          }
        }
      }
      allow_interrupt = true
    }
  }
}


# Define Intent for Booking Meetings
resource "aws_lexv2models_intent" "book_meeting_intent" {
  bot_id                 = aws_lexv2models_bot.meety_bot.id
  bot_version            = aws_lexv2models_bot_locale.en_us_locale.bot_version
  name                   = "BookMeeting"
  description            = "Book a meeting"
  locale_id              = aws_lexv2models_bot_locale.en_us_locale.locale_id
  # # Priority of the slots
  # slot_priority {
  #   priority = 1
  #   slot_id = "FullName"
  # }
  # slot_priority {
  #   priority = 2
  #   slot_id = "MeetingDate"
  # }
  # slot_priority {
  #   priority = 3
  #   slot_id = "MeetingTime"
  # }
  # slot_priority {
  #   priority = 4
  #   slot_id = "MeetingDuration"
  # }
  # slot_priority {
  #   priority = 5
  #   slot_id = "AttendeeEmail"
  # }
  # Provide each utterance as a separate block
  confirmation_setting {
    active = true
    prompt_specification {
      message_group {
        message {
          plain_text_message {
            value = "Do you want to proceed with the meeting?"
          }
        }
      }
      max_retries = 3
      allow_interrupt = true
    }
    declination_response {
      message_group {
        message {
          plain_text_message {
            value = "No worries, I will cancel the request. Please let me know if you want me to restart the process!"
          }
        }
      }
      allow_interrupt = false
    }
  }
  sample_utterance {
    utterance = "I want to book a meeting"
  }

  sample_utterance {
    utterance = "Can I book a meeting?"
  }

  sample_utterance {
    utterance = "Can you help me book a meeting?"
  }
}

resource "aws_lexv2models_slot_type" "MeetingDuration" {
  bot_id      = aws_lexv2models_bot.meety_bot.id
  bot_version = aws_lexv2models_bot_locale.en_us_locale.bot_version
  locale_id   = aws_lexv2models_bot_locale.en_us_locale.locale_id
  name        = "MeetingDuration"
  slot_type_values {
    sample_value {
      value = 30
    }
  }
  slot_type_values {
    sample_value {
      value = 60
    }
  }
  value_selection_setting {
    resolution_strategy = "OriginalValue"
  }
}

resource "aws_lexv2models_slot" "full_name" {
  bot_id      = aws_lexv2models_bot.meety_bot.id
  bot_version = aws_lexv2models_bot_locale.en_us_locale.bot_version
  intent_id   = aws_lexv2models_intent.book_meeting_intent.intent_id
  locale_id   = aws_lexv2models_bot_locale.en_us_locale.locale_id
  name        = "FullName"
  description = "User's full name"
  slot_type_id = "AMAZON.FirstName"
  value_elicitation_setting {
    slot_constraint = "Required"
    prompt_specification {
      allow_interrupt            = true
      max_retries                = 1
      message_selection_strategy = "Random"

      message_group {
        message {
          plain_text_message {
            value = "What is your name?"
          }
        }
      }
    }
  }
}


resource "aws_lexv2models_slot" "meeting_date" {
  bot_id      = aws_lexv2models_bot.meety_bot.id
  bot_version = aws_lexv2models_bot_locale.en_us_locale.bot_version
  intent_id   = aws_lexv2models_intent.book_meeting_intent.intent_id
  locale_id   = aws_lexv2models_bot_locale.en_us_locale.locale_id
  # depends_on = [ aws_lexv2models_slot.full_name ]
  name        = "MeetingDate"
  description = "Date for the meeting"
  slot_type_id         = "AMAZON.Date"
  
  value_elicitation_setting {
    slot_resolution_setting {
      slot_resolution_strategy = "Default"
    }
    wait_and_continue_specification {
      active = true
      waiting_response {
        message_group {
          message {
            plain_text_message {
              value = "-"
            }
          }
        }
      }
      continue_response {
        message_group {
          message {
            plain_text_message {
              value = "-"
            }
          }
        }
      }

    }
    slot_constraint = "Required"
    prompt_specification {
      allow_interrupt            = true
      max_retries                = 1
      message_selection_strategy = "Random"

      message_group {
        message {
          plain_text_message {
            value = "When do you want to meet?"
          }
        }
      }
    }
  }
}

resource "aws_lexv2models_slot" "meeting_time" {
  bot_id      = aws_lexv2models_bot.meety_bot.id
  bot_version = aws_lexv2models_bot_locale.en_us_locale.bot_version
  intent_id   = aws_lexv2models_intent.book_meeting_intent.intent_id
  locale_id   = aws_lexv2models_bot_locale.en_us_locale.locale_id
  # depends_on = [ aws_lexv2models_slot.meeting_date ]
  name        = "MeetingTime"
  description = "Time for the meeting"
  slot_type_id         = "AMAZON.Time"
  value_elicitation_setting {
    slot_constraint = "Required"
    prompt_specification {
      allow_interrupt            = true
      max_retries                = 1
      message_selection_strategy = "Random"

      message_group {
        message {
          plain_text_message {
            value = "What time should the meeting be scheduled for?"
          }
        }
      }
    }
  }
}

resource "aws_lexv2models_slot" "meeting_duration" {
  bot_id      = aws_lexv2models_bot.meety_bot.id
  bot_version = aws_lexv2models_bot_locale.en_us_locale.bot_version
  intent_id   = aws_lexv2models_intent.book_meeting_intent.intent_id
  locale_id   = aws_lexv2models_bot_locale.en_us_locale.locale_id
  # depends_on = [ aws_lexv2models_slot_type.MeetingDuration ]
  name        = "MeetingDuration"
  description = "Meeting Duration"
  slot_type_id = aws_lexv2models_slot_type.MeetingDuration.slot_type_id

  value_elicitation_setting {
    slot_constraint = "Required"
    prompt_specification {
      allow_interrupt            = false
      max_retries                = 1
      message_selection_strategy = "Random"

      message_group {
        message {
          plain_text_message {
            value = "How long do you want to meet in minutes? (30 or 60)"
          }
        }
      }
    }
  }
}


resource "aws_lexv2models_slot" "attendee_email" {
  bot_id      = aws_lexv2models_bot.meety_bot.id
  bot_version = aws_lexv2models_bot_locale.en_us_locale.bot_version
  intent_id   = aws_lexv2models_intent.book_meeting_intent.intent_id
  locale_id   = aws_lexv2models_bot_locale.en_us_locale.locale_id
  # depends_on = [ aws_lexv2models_slot.meeting_duration ]
  name        = "AttendeeEmail"
  description = "Attendee Email"
  slot_type_id = "AMAZON.EmailAddress"

  value_elicitation_setting {
    slot_constraint = "Required"
    prompt_specification {
      allow_interrupt            = true
      max_retries                = 1
      message_selection_strategy = "Random"

      message_group {
        message {
          plain_text_message {
            value = "Please provide me your email address."
          }
        }
      }
    }
  }
}



resource "aws_lexv2models_intent" "fallback_intent" {
  bot_id      = aws_lexv2models_bot.meety_bot.id
  bot_version = aws_lexv2models_bot_locale.en_us_locale.bot_version
  locale_id   = aws_lexv2models_bot_locale.en_us_locale.locale_id
  name        = "FallbackIntent"
  description = "Default intent when no other intent matches OK?"
  parent_intent_signature = "AMAZON.FallbackIntent"

  closing_setting {
    active = true
    closing_response {
      message_group {
        message {
          plain_text_message {
            value = "Sorry, I did not get it. I am an expert in scheduling meetings. Do you need help with that?"
          }
        }
      }
    }
  }
}




# # Define Bot Alias
# resource "aws_lexv2models_bot_alias" "meety_bot_alias" {
#   bot_id       = aws_lexv2models_
#   name         = "TestAlias"
#   description  = "Alias for testing Meety bot"
#   bot_version  = "DRAFT"
# }
