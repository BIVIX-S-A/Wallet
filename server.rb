require 'sinatra/activerecord'
require_relative 'models/user'
require_relative 'models/account'
require_relative 'models/card'
require_relative 'models/movement'
require_relative 'models/transaction'
require 'sinatra'
require 'bundler/setup'
require 'sinatra/reloader' if Sinatra::Base.environment == :development
require 'bcrypt'

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
    erb :'/index'
  end

  get '/transfers' do
    erb :'/transfers'
  end

  get '/register' do
    erb :'/register'
  end
end
