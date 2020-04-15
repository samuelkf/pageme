require 'sinatra'
require 'haml'
require 'json'
require 'net/https'

get '/styles.css' do 
  scss :styles
end

get '/' do
  @title = 'page me 📟'
  haml :form
end

post '/sendmessage' do

  return_message = {}

  ENV.each { |var| puts var }

  message_text = params[:message_text].to_s

  # Make a request to the DAPNET API

  uri = URI.parse('https://hampager.de/api/calls')
  
  header = {'Content-Type': 'application/json'}
  call = {
    'text': message_text,
    'callSignNames': [ENV['DEST_CALLSIGN']], 
    'transmitterGroupNames': [ENV['TRANSMITTER_GROUP']], 
    'emergency': false
  }

  # Create the HTTP objects
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.basic_auth(ENV['DAPNET_USER'], ENV['DAPNET_PASS'])
  request.body = call.to_json
  
  # Send the request
  response = https.request(request)

  p response.code
  p response.body

  if response.code == '201'

    return_message[:status] = 'success'

    # Make external API calls in a new thread
    Thread.new do

      # Send a notification using Pushover
      url = URI.parse("https://api.pushover.net/1/messages.json")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({
        :token => ENV['PUSHOVER_APP_TOKEN'],
        :user => ENV['PUSHOVER_USER_KEY'],
        :message => params[:message_text].to_s,
      })
      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true
      res.verify_mode = OpenSSL::SSL::VERIFY_PEER
      res.start {|http| http.request(req) }

      # Trigger an IFTTT event
      url = URI.parse("https://maker.ifttt.com/trigger/pageme_message_sent/with/key/#{ENV['IFTTT_MAKER_KEY']}")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({
        :value1 => params[:message_text].to_s,
        :value2 => request.ip
      })
      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true
      res.verify_mode = OpenSSL::SSL::VERIFY_PEER
      res.start {|http| http.request(req) }
    end

  else
    status 502
    return_message[:status] = 'failed'
  end

  return_message.to_json
end
