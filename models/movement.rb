class Movement < ActiveRecord::Base
  belongs_to :account
  belongs_to :bivix_transaction, class_name: 'Transaction', foreign_key: 'transaction_id'
end
