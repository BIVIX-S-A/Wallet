require 'sinatra/activerecord'
require_relative 'models/user'
require_relative 'models/account'
require_relative 'models/card'
require_relative 'models/movement'
require_relative 'models/transaction'
require 'sinatra'
require 'pony'
require 'valid_email2'
require 'dotenv/load'
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

  Dotenv.load

  enable :sessions

  Pony.options = {
    via: :smtp,
    via_options:{
      address: ENV['SMTP_ADDRESS'],
      port: ENV['SMTP_PORT'].to_i,
      user_name: ENV['SMTP_USER'],
      password: ENV['SMTP_PASS'],
      authentication: :plain,
      domain: ENV['SMTP_DOMAIN'],
      enable_starttls_auto: true
    }
  }

  get '/' do
    erb :'index', layout: true
  end

  get '/login' do
    erb :'login', layout: true
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
    erb :'transfers', layout: false
  end

  get '/register' do
    erb :'register', layout: true
  end

  post '/register' do
    email = params[:email]
    
    #Genarating a radom code
    code = rand(10**(ENV['VERIFICATION_CODE_LENGTH'].to_i - 1)...10**ENV['VERIFICATION_CODE_LENGTH'].to_i)

    #Storing it in session
    session[:verification_code] = code.to_s
    session[:verification_email] = email
    session[:code_expiry] = Time.now + ENV['VERIFICATION_CODE_EXPIRY'].to_i

    #Send mail using pony structure
    Pony.mail(
      to: email,
      from: ENV['SMTP_FROM'],
      subject: 'Your BIVIX verification code',
      body: "You are just a few steps away from join to the BIVIX family, this is your verification code = #{code}")

      redirect 'register/verify'
  end

  get '/register/verify' do
    erb :'code_verification', layout: :'layout'
  end

  post '/register/verify' do
    entered_code = params[:code]
    if entered_code == session[:verification_code] && Time.now < session[:code_expiry]
      user = User.create(email: session[:verification_email])
      session[:user_id] = user.id
      redirect '/registration-final'
    else
      @error = "Invalid or expired verification code."
      erb :'code_verification', layout: :'layout'
    end
  end

  get '/registration-final' do
    erb :'registration_final'
  end

  get '/dashboard' do
    erb :'dashboard', layout: false
  end
end
