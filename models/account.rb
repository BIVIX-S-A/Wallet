class Account < ActiveRecord::Base
  belongs_to :user
  has_may :source_transaction, class_name: 'Transaction', foreign_key: :source_account_id
end
