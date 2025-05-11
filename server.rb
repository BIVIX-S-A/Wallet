require 'sinatra'

set :views, File.expand_path('app/views', __dir__)
set :public, File.expand_path('public', __dir__)

class App < Sinatra::Application
  get '/' do
    erb :'home/index'
  end
end
