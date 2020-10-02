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
riya_personal = "+17036087492"

client = Client(account_sid, auth_token)

messages = client.messages.list(from_=repaint_test_number, limit=20)

message_nicely = lambda body, time: f"[At {time}]: \n{body}"
print_message = lambda msg: print(message_nicely(msg.body, msg.date_sent))
for i in range(len(messages)):
    print_message(messages[i])
print('\n--\ndone')
