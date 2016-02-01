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
  content_type :json
  return_message = {}

  agent = Mechanize.new
  agent.user_agent_alias = 'Windows IE 11'

  page = agent.get ('http://www.paging.vodafone.net/login.jsp')
  form1 = page.form('formSendMessage1')
  form1.to_string = "***REMOVED***"
  page = agent.submit(form1)
  form2 = page.form('sendmessage')
  form2.mesg_to_send = params[:message_text].to_s
  page = agent.submit(form2)

  if page.search("Message successfully sent")
    return_message[:status] = 'success'
    url = URI.parse("https://api.pushover.net/1/messages.json")
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data({
      :token => "***REMOVED***",
      :user => "***REMOVED***",
      :message => params[:message_text].to_s,
    })
    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true
    res.verify_mode = OpenSSL::SSL::VERIFY_PEER
    res.start {|http| http.request(req) }
  else
    status 502
    return_message[:status] = 'failed'
  end

  return_message.to_json
end