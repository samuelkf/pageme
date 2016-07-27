# pageme
#### A sinatra application for sending messages to my pager

This has a fairly specific use case. I very much doubt that it will be of use to anyone :-)

The app presents a simple text input field where a message can be entered.
Messages submitted through the form are fed into Vodafone's online pager portal using Mechanize. Notifications are sent to Pushover and an IFTTT trigger is called. I have the IFTTT trigger configured to log the details of the incoming message to a Google sheet.

## Running it

This is designed to run on Heroku and can be run locally using `heroku local`.

The app requires some environment variables to be configured:

- `PAGER_NUMBER` The number that you want to page (this must be a Vodafone UK contract pager)
- `PUSHOVER_USER_KEY` Your Pushover user key
- `PUSHOVER_APP_TOKEN` Your Pushover app token
- `IFTTT_MAKER_KEY` Your IFTTT Maker key

Set these for the Heroku app using `heroku config:set` and locally by adding them to a `.env` file.