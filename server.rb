require 'sinatra'
require 'bundler/setup'
require 'sinatra/reloader' if Sinatra::Base.environment == :development

set :views, File.expand_path('app/views', __dir__)
set :public, File.expand_path('public', __dir__)

class App < Sinatra::Application
  register Sinatra::Reloader
  after_reload do
    puts 'Reloaded...'
  end

  get '/' do
    erb :'home/index'
  end

  get '/transfers' do
    erb :'home/transfers'
  end
end
