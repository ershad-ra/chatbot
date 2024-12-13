import boto3
import json

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Meetings')


def lambda_handler(event, context):
    try:
        # Query pending meetings
        response = table.query(
            IndexName='StatusIndex',
            KeyConditionExpression=boto3.dynamodb.conditions.Key('status').eq('pending')
        )
        pending_meetings = response.get('Items', [])

        # Handle pagination
        while 'LastEvaluatedKey' in response:
            response = table.query(
                IndexName='StatusIndex',
                KeyConditionExpression=boto3.dynamodb.conditions.Key('status').eq('pending'),
                ExclusiveStartKey=response['LastEvaluatedKey']
            )
            pending_meetings.extend(response.get('Items', []))

        return {
            'statusCode': 200,
            'body': json.dumps(pending_meetings),
            'headers': {'Content-Type': 'application/json'}
        }

    except Exception as e:
        print(f"Error querying DynamoDB: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps('Internal server error'),
            'headers': {'Content-Type': 'application/json'}
        }
