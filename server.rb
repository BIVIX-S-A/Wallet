require 'sinatra/activerecord'
require_relative 'models/user'
require_relative 'models/account'
require_relative 'models/card'
require_relative 'models/movement'
require_relative 'models/transaction'
require_relative 'models/contact'
require 'sinatra'
require 'pony'
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
    erb :'index', layout: false
  end

  get '/login' do
    erb :'login', layout: true
  end

  post '/login' do
    email = params[:login_mail]
    password = params[:login_password]
    user = User.find_by(email: email)

    if user && user.authenticate(password)
      session[:user_id] = user.id
      redirect '/dashboard'
    else
      @error = "Invalid email or password"
      erb :login
    end
  end

  get '/transfers' do
    halt(redirect('/')) unless session[:user_id]
    @user = User.find(session[:user_id])

    if params[:contact_id]
      contact_account = Account.find_by(id: params[:contact_id])
      @selected_alias = contact_account.alias if contact_account
    end

    erb :'transfers', layout: true
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
    entered_code = params[:verification_code]
    if entered_code == session[:verification_code] && Time.now < session[:code_expiry]
      user = User.create(
        email: session[:verification_email],
        password: 'Temp1234*',
        name: 'Pending'
        )
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

  post '/register/complete' do
    halt(redirect('/login')) unless session[:user_id]

    user = User.find(session[:user_id])
    
    user.update(
      name: params[:name],
      surname: params[:surname],
      dni: params[:dni],
      birth_date: params[:birth_date],
      phone: params[:phone],
      address: params[:address],
      password: params[:password],
      marital_status: params[:marital_status]&.to_i,
      legal_entity: params[:legal_entity] == 'true'
    )
    
    if user.errors.empty?
      Account.create(user: user, balance: 0.0)
      redirect '/dashboard'
    else
      @errors = user.errors.full_messages
      erb :'registration_final'
    end
  end


  get '/dashboard' do
    halt(redirect('/login')) unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    @movements = @account.movements       
                       .includes(bivix_transaction: [:source_account, :target_account])
                       .order(id: :desc)
                       .limit(100)
    erb :'dashboard', layout: true
  end

  get '/check_session' do
    if session[:user_id]
      redirect '/dashboard'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/card' do
    halt(redirect('/login')) unless session[:user_id]
    erb :'card', layout: true
  end

  get '/savings' do
    halt(redirect('/login')) unless session[:user_id]
    erb :'savings', layout: true
  end

  get '/charge-link' do
    halt(redirect('/login')) unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    erb :'charge-link', layout: true
  end

  get '/charge-qr' do
    halt(redirect('/login')) unless session[:user_id]
    @user = User.find(session[:user_id])
    erb :'charge-qr', layout: true
  end

  get '/history' do
    halt(redirect('/login')) unless session[:user_id]
    @user = User.find(session[:user_id])
    @movements = @user.account.movements.order(created_at: :desc)
    erb :'history', layout: true
  end

  get '/pay-qr' do
    halt(redirect('/login')) unless session[:user_id]
    @user = User.find(session[:user_id])
    erb :'pay-qr', layout: false
  end

  get '/select-contact' do
    halt(redirect('/login')) unless session[:user_id]
    
    @user = User.find(session[:user_id])
    @contacts = @user.account.owned_contacts_entries
    
    erb :'select-contact', layout: false  
  end

  post '/transfer-success' do

    halt(redirect('/login')) unless session[:user_id]
    @user = User.find(session[:user_id])

    begin
      @amount = BigDecimal(params[:amount])
    rescue ArgumentError
      @error = "Invalid amount format."
      return erb :'transfers', layout: true
    end

    debit_account_id = params[:debit_account_id].to_i
    @selected_alias = params[:recipient_identifier].to_s.strip
    @category = params[:category]

    halt(403, "Forbidden.") unless @user.account.id == debit_account_id
    halt(400, "Invalid amount.") unless @amount > 0
    halt(400, "No recipient entered.") if @selected_alias.empty?

    debit_account = @user.account
    credit_account = Account.find_by(alias: @selected_alias) || Account.find_by(cvu: @selected_alias)

    unless credit_account
      @error = "Recipient account not found. Please check the Alias or CVU."
      return erb :'transfers', layout: true
    end

    begin
      description = "Transfer from #{debit_account.user.name} to #{credit_account.user.name}"
      Transaction.create_transfer(
        source_account: debit_account,
        target_account: credit_account,
        amount: @amount,
        category: @category,
        description: description
      )

      erb :'transfer-success', layout: false

    rescue ActiveRecord::RecordInvalid => e
      @error = e.message
      erb :'transfers', layout: true 
    rescue => e
      @error = "An unexpected error occurred. Please try again."
      erb :'transfers', layout: true
    end
  end

  get '/add-contact' do
    halt(redirect('/login')) unless session[:user_id]
    erb :'add-contact', layout: false
  end

  post '/add-contact' do
    halt(redirect('/login')) unless session[:user_id]
    
    @user = User.find(session[:user_id])
    
    contact_account = Account.joins(:user).find_by(users: { email: params[:contact_email] })
    
    if contact_account && contact_account != @user.account
      Contact.create(
        owner_account: @user.account,
        contact_account: contact_account,
        custom_name: params[:custom_name]
      )
      redirect '/select-contact'
    else
      @error = "Contact not found or invalid"
      erb :'add-contact', layout: false
    end
  end

end
