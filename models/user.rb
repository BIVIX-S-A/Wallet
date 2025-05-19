class User < ActiveRecord::Base
  has_one :account

  validates :name, presence: true
end
