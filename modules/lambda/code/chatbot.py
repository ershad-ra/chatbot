import json
import os
import boto3

bot = boto3.client('lexv2-runtime')

def lambda_handler(event, context):

    # Get Lex bot values from environment variables.
    lex_bot_id = os.environ.get('LEX_BOT_ID')
    lex_bot_alias_id = os.environ.get('LEX_BOT_ALIAS_ID')

    user_input = json.loads(event['body'])['message']

    response = bot.recognize_text(
        botId=lex_bot_id,
        botAliasId=lex_bot_alias_id,
        localeId='en_US',
        sessionId='your_session_id',  # You can further parameterize this if needed.
        text=user_input
    )

    bot_response = response['messages'][0]['content']

    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Credentials': True,
        },
        'body': json.dumps({'botResponse': bot_response})
    }
