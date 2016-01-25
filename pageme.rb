require 'mechanize'
require 'logger'

message = ARGV[0].to_s

agent = Mechanize.new{|a| a.log = Logger.new(STDERR) }
agent.user_agent_alias = 'Windows IE 11'

page = agent.get ('http://www.paging.vodafone.net/login.jsp')
form1 = page.form('formSendMessage1')
form1.to_string = "***REMOVED***"
page = agent.submit(form1)
form2 = page.form('sendmessage')
form2.mesg_to_send = message
page = agent.submit(form2)

if page.search("Message successfully sent")
  puts "Message successfully sent"
else
  puts "Error"
end