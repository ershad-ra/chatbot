import boto3
import json

# Initialize Lex client
bot = boto3.client('lexv2-runtime')


def lambda_handler(event, context):
    try:
        # Parse user input
        body = json.loads(event['body'])
        user_input = body['message']

        # Recognize text using Lex
        response = bot.recognize_text(
            botId='MeetyBot',
            botAliasId='TSTALIASID',
            localeId='en_US',
            sessionId='your_session_id',
            text=user_input
        )

        # Extract bot response
        bot_response = response['messages'][0]['content']

        return {
            'statusCode': 200,
            'body': json.dumps({'botResponse': bot_response}),
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Credentials': True,
                'Content-Type': 'application/json'
            }
        }

    except Exception as e:
        print(f"Error communicating with Lex: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps('Internal server error'),
            'headers': {'Content-Type': 'application/json'}
        }
