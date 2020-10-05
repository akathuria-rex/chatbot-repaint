import os
from twilio.rest import Client

# Import keys from env vars
sid = os.environ['AURUM_TWILIO_SID']
secret = os.environ['AURUM_TWILIO_SECRET']
auth_token = os.environ['AURUM_TWILIO_AUTH_TOKEN']
account_sid = os.environ['AURUM_TWILIO_ACCOUNT_SID']

# Setup test numbers
repaint_test_number = os.environ['AURUM_TWILIO_REPAINT_TEST_NUMBER']
aurum_personal = "+14082422199"
riya_personal = "7036087492"

client = Client(account_sid, auth_token)

message = client.messages.create(from_=repaint_test_number,
                                to=aurum_personal,
                                body="put your mask on")
