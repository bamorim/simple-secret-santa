require 'rubygems'
require 'sinatra'
require 'mandrill'
require 'haml'
require './people'

get '/' do
  haml :index
end

post '/send' do
  params.symbolize_keys!
  ppl = People.new(params[:people])
  if ppl.send_emails
    "Emails sent! :)"
  else
    "Emails not sent! :("
  end
end