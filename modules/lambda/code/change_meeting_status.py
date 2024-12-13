import boto3
import json

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Meetings')


def lambda_handler(event, context):
    try:
        # Parse request body
        body = json.loads(event['body'])
        meeting_id = body['meetingId']
        new_status = body['newStatus']

        # Update the meeting status
        response = table.update_item(
            Key={'meetingId': meeting_id},
            UpdateExpression='SET #status = :new_status',
            ExpressionAttributeNames={'#status': 'status'},
            ExpressionAttributeValues={':new_status': new_status},
            ReturnValues='ALL_NEW'
        )

        return {
            'statusCode': 200,
            'body': json.dumps('Meeting status successfully updated'),
            'headers': {'Content-Type': 'application/json'}
        }

    except Exception as e:
        print(f"Error updating DynamoDB: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps('Internal server error'),
            'headers': {'Content-Type': 'application/json'}
        }
