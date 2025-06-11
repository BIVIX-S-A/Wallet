class User < ActiveRecord::Base

  has_secure_password
  
  has_one :account

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

end
