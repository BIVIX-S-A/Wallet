require 'sinatra/activerecord'
require_relative 'models/user'
require_relative 'models/account'
require_relative 'models/card'
require_relative 'models/movement'
require_relative 'models/transaction'
require 'sinatra'
require 'bundler/setup'
require 'sinatra/reloader' if Sinatra::Base.environment == :development

set :views, File.expand_path('views', __dir__)
set :public_folder, File.expand_path('public', __dir__)

class App < Sinatra::Application
  configure :development do
    register Sinatra::Reloader
    after_reload do
      puts 'Reloaded...'
    end
  end

  get '/' do
    erb :'index'
  end

  get '/login' do
    erb :'login'
  end

  post '/login' do
    email = params[:email]
    passwd = params[:password]
    user = User.find_by(email: email)

    if user && user.authenticate(password)
      session[:user_id] = user_id
      redirect '/dashboard'
    else
      @error = "Invalid email or password"
      erb :login
    end
  end

  get '/transfers' do
    erb :'transfers'
  end

  get '/register' do
    erb :'register'
  end

  get '/dashboard' do
    erb :'dashboard'
  end
end
