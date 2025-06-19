class Transaction < ActiveRecord::Base
  belongs_to :source_account, class_name: 'Account', foreign_key: 'source_account_id'
  belongs_to :target_account, class_name: 'Account', foreign_key: 'target_account_id'
  
  validates :source_account, presence: true
  validates :target_account, presence: true
  validate :check_balance

  after_create :transfer_balance

  private

  def transfer_balance
    #Making all in a db transaction for avoid inconsistencies
    ActiveRecord::Base.transaction do
      source_account.lock!
      target_account.lock!
      
      source_account.balance -= amount
      source_account.save!

      target_account.balance += amount
      target_account.save!

      Movement.create!(account: source_account, bivix_transaction: self, amount: -amount, movement_date: Time.now)
      Movement.create!(account: target_account, bivix_transaction: self, amount: amount, movement_date: Time.now)
    end
  end

  private

  def check_balance
    if source_account && source_account.balance < amount
      errors.add(:base, "The balance isn't enough for this transaction")
    end
  end
end