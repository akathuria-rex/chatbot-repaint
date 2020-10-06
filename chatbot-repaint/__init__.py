import os
from flask import Flask, request, redirect
from twilio.twiml.messaging_response import MessagingResponse, Message

app = Flask(__name__)

@app.route('/sms', methods=['GET', 'POST'])
def sms_reply():
    """Respond to an incoming text message. """
    # Start TwiML Response
    response = MessagingResponse()
    message = Message()

    # Get the user's text message
    text = request.values.get('body', None)

    # Add text to our message
    message.body("Two can play that game!\n" + str(text))

    # Add media to our message
    cool_living_room_image_url = \
        "https://qa-cdn.rexhomes.com/listing/e69b9c60821e4e5f90d6a2dfcd567644/image.1550854689032.jpg"
    message.media(cool_living_room_image_url)

    # Add our message to our response
    response.append(message)

    # Return the message
    return str(response)

if __name__ == '__main__':
    app.run()
