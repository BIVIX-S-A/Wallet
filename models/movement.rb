class Movement < ActiveRecord::Base
  belongs_to :account
  belongs_to :bivix_transaction, class_name: 'Transaction', foreign_key: 'transaction_id'

  validates :amount, presence: true
  validates :account_id, presence: true
  validates :transaction_id, presence: true
end
