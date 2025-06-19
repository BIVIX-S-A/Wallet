class User < ActiveRecord::Base

  has_secure_password
  
  has_one :account

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }


  validate :email_format

  private

  def email_format
    unless email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      errors.add(:email, "is invalid")
    end
  end

end
