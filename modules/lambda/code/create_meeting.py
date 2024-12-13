import boto3
import json
import uuid
from datetime import datetime, timedelta

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Meetings')


def get_session_attributes(intent_request):
    """Retrieve session attributes from Lex intent request."""
    session_state = intent_request.get('sessionState', {})
    return session_state.get('sessionAttributes', {})


def get_slots(intent_request):
    """Retrieve slots from Lex intent request."""
    return intent_request['sessionState']['intent']['slots']


def get_slot(intent_request, slot_name):
    """Retrieve a specific slot value from Lex intent request."""
    slots = get_slots(intent_request)
    if slots and slot_name in slots and slots[slot_name]:
        return slots[slot_name]['value']['interpretedValue']
    return None


def close(intent_request, session_attributes, fulfillment_state, message):
    """Close the Lex dialog with a response."""
    intent_request['sessionState']['intent']['state'] = fulfillment_state
    return {
        'sessionState': {
            'sessionAttributes': session_attributes,
            'dialogAction': {'type': 'Close'},
            'intent': intent_request['sessionState']['intent']
        },
        'messages': [message],
        'sessionId': intent_request['sessionId'],
        'requestAttributes': intent_request.get('requestAttributes', None),
    }


def calculate_end_time(start_time_str, duration_minutes):
    """Calculate the end time for a meeting."""
    start_time = datetime.strptime(start_time_str, '%H:%M').time()
    end_time = (datetime.combine(datetime.min, start_time) + timedelta(minutes=duration_minutes)).time()
    return end_time.strftime('%H:%M')


def check_meeting_slot(prop_date, prop_start, prop_dur):
    """Check if a meeting slot is available."""
    proposed_date = datetime.strptime(prop_date, '%Y-%m-%d').date()
    proposed_start_time = datetime.strptime(prop_start, '%H:%M').time()
    proposed_end_time = (datetime.combine(proposed_date, proposed_start_time) + timedelta(minutes=prop_dur)).time()

    start_time_str = proposed_start_time.strftime('%H:%M')
    end_time_str = proposed_end_time.strftime('%H:%M')

    query_response = table.query(
        IndexName='StatusIndex',
        KeyConditionExpression=boto3.dynamodb.conditions.Key('status').eq('approved') &
                               boto3.dynamodb.conditions.Key('date').eq(proposed_date.isoformat()),
        FilterExpression=(boto3.dynamodb.conditions.Attr('startTime').gt(start_time_str) &
                          boto3.dynamodb.conditions.Attr('startTime').lt(end_time_str)) |
                         boto3.dynamodb.conditions.Attr('startTime').eq(start_time_str) |
                         (boto3.dynamodb.conditions.Attr('endTime').gt(start_time_str) &
                          boto3.dynamodb.conditions.Attr('endTime').lt(end_time_str))
    )

    return not bool(query_response.get('Items', []))


def create_meeting(intent_request):
    """Create a new meeting in DynamoDB."""
    session_attributes = get_session_attributes(intent_request)
    proposed_date = get_slot(intent_request, 'MeetingDate')
    proposed_start_time = get_slot(intent_request, 'MeetingTime')
    proposed_duration = int(get_slot(intent_request, 'MeetingDuration'))
    email = get_slot(intent_request, 'AttendeeEmail')
    name = get_slot(intent_request, 'FullName')

    meeting_id = str(uuid.uuid4())
    proposed_end_time = calculate_end_time(proposed_start_time, proposed_duration)
    is_conflict = not check_meeting_slot(proposed_date, proposed_start_time, proposed_duration)

    item = {
        'meetingId': meeting_id,
        'attendeeName': name,
        'email': email,
        'date': proposed_date,
        'duration': proposed_duration,
        'startTime': proposed_start_time,
        'endTime': proposed_end_time,
        'status': 'pending',
        'isConflict': is_conflict
    }

    try:
        table.put_item(Item=item)
        message = {
            'contentType': 'PlainText',
            'content': f"Thank you {name}. Your meeting request for {proposed_date} from {proposed_start_time} "
                       f"to {proposed_end_time} has been created. Have a nice day!"
        }
        return close(intent_request, session_attributes, "Fulfilled", message)

    except Exception as e:
        print(f"Error creating meeting: {str(e)}")
        message = {
            'contentType': 'PlainText',
            'content': "Sorry, there was an error creating your meeting. Please try again later."
        }
        return close(intent_request, session_attributes, "Failed", message)


def lambda_handler(event, context):
    """Main Lambda function handler."""
    intent_request = json.loads(event['body'])
    intent_name = intent_request['sessionState']['intent']['name']

    if intent_name == 'BookMeeting':
        return create_meeting(intent_request)
    else:
        return {
            'statusCode': 400,
            'body': json.dumps('Invalid intent request'),
            'headers': {'Content-Type': 'application/json'}
        }
