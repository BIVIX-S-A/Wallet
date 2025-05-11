require 'sinatra'
set :views, File.expand_path('app/views', __dir__)
set :public_folder, File.expand_path('public', __dir__)

get '/' do
  erb :'home/index'
end

