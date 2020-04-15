# pageme
#### A sinatra application for sending messages to my pager

This has a fairly specific use case. I very much doubt that it will be of use to anyone :-)

The app presents a simple text input field where a message can be entered.
Messages submitted through the form are sent to my pager via DAPNET.

## Running it

This is designed to run on Heroku and can be run locally using `heroku local`.

The app requires some environment variables to be configured:

- `DAPNET_USER` Username for DAPNET API
- `DAPNET_PASS` Password for DAPNET API
- `DEST_CALLSIGN` Destination callsign for messages
- `TRANSMITTER_GROUP` Dapnet transmitter group
- `PUSHOVER_APP_TOKEN` Pushover app token
- `PUSHOVER_USER_KEY` Pushover user key

Set these for the Heroku app using `heroku config:set` and locally by adding them to a `.env` file.
