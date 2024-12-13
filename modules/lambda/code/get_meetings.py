import boto3
import json
from datetime import datetime, timedelta

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Meetings')


def lambda_handler(event, context):
    # Parse query parameters
    query_params = event.get('queryStringParameters', {})
    start_date_str = query_params.get('startDate')
    end_date_str = query_params.get('endDate')

    # Validate query parameters
    if not start_date_str or not end_date_str:
        return {
            'statusCode': 400,
            'body': json.dumps('Missing required query parameters: startDate or endDate'),
            'headers': {'Content-Type': 'application/json'}
        }

    # Convert dates
    try:
        start_date = datetime.fromisoformat(start_date_str) - timedelta(days=1)
        end_date = datetime.fromisoformat(end_date_str)
    except ValueError:
        return {
            'statusCode': 400,
            'body': json.dumps('Invalid date format. Use ISO 8601 format.'),
            'headers': {'Content-Type': 'application/json'}
        }

    # Query DynamoDB
    try:
        response = table.query(
            IndexName='StatusIndex',
            KeyConditionExpression=boto3.dynamodb.conditions.Key('status').eq('approved') &
                                   boto3.dynamodb.conditions.Key('date').between(start_date.isoformat(), end_date.isoformat())
        )
        approved_meetings = response.get('Items', [])

        # Handle pagination
        while 'LastEvaluatedKey' in response:
            response = table.query(
                IndexName='StatusIndex',
                KeyConditionExpression=boto3.dynamodb.conditions.Key('status').eq('approved') &
                                       boto3.dynamodb.conditions.Key('date').between(start_date.isoformat(), end_date.isoformat()),
                ExclusiveStartKey=response['LastEvaluatedKey']
            )
            approved_meetings.extend(response.get('Items', []))

        return {
            'statusCode': 200,
            'body': json.dumps(approved_meetings),
            'headers': {'Content-Type': 'application/json'}
        }

    except Exception as e:
        print(f"Error querying DynamoDB: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps('Internal server error'),
            'headers': {'Content-Type': 'application/json'}
        }
