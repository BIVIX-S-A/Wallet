class Account < ActiveRecord::Base
  belongs_to :user
  has_one :card
  has_many :source_transactions, class_name: 'Transaction', foreign_key: :source_account_id
  has_many :target_transactions, class_name: 'Transaction', foreign_key: :target_account_id
end
