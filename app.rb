require 'sinatra'
require 'haml'
require 'json'
require 'mechanize'
require 'net/https'

get '/styles.css' do 
  scss :styles
end

get '/' do
  @title = 'page me 📟'
  haml :form
end

post '/sendmessage' do

  ENV.each { |var| puts var }

  # Create an instance of Mechanize and set the UA string.
  agent = Mechanize.new
  agent.user_agent_alias = 'Windows IE 11'

  # Enter the pager number into the first form and submit
  page = agent.get ('http://www.paging.vodafone.net/login.jsp')
  form1 = page.form('formSendMessage1')
  form1.to_string = ENV['PAGER_NUMBER']
  page = agent.submit(form1)

  # Enter the message into the second page and submit
  form2 = page.form('sendmessage')
  form2.mesg_to_send = params[:message_text].to_s
  page = agent.submit(form2)

  # Return a success/failure status based on the content of Vodafone's confirmation page
  content_type :json
  return_message = {}

  if page.search("Message successfully sent")

    return_message[:status] = 'success'

    # Make external API calls in a new thread
    Thread.new do

      # Send a notification using Pushover
      url = URI.parse("https://api.pushover.net/1/messages.json")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({
        :token => "***REMOVED***",
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