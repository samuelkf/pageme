require 'sinatra'
require 'haml'

get '/styles.css' do 
  scss :styles
end

get '/' do
  @title = 'page me'
  haml :form
end