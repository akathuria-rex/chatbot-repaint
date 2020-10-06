import os
from flask import Flask, request, redirect
from twilio.twiml.messaging_response import MessagingResponse

app = Flask(__name__)

@app.route('/sms', methods=['GET', 'POST'])
def sms_reply():
    """Respond to an incoming text message. """
    # Start TwiML Response
    resp = MessagingResponse()

    # Get the user's text message
    text = request.values.get('body', None)

    # Add message to our response
    resp.message("Two can play that game!\n" + str(text))

    # Return the message
    return str(resp)

if __name__ == '__main__':
    app.run()
