class User < ActiveRecord::Base
  has_secure_password
  
  has_one :account

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :name, presence: true

  def self.create_user(email, password)
    create(email: email, password: password)
  end

  def self.authenticate(email, password)
    user = find_by(email: email)
    user && user.authenticate(password) ? user : nil
  end

end