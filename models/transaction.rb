class Transaction < ActiveRecord::Base
  belongs_to :source_account, class_name: 'Account', foreign_key: 'source_account_id'
  belongs_to :target_account, class_name: 'Account', foreign_key: 'target_account_id'
  
  validates :source_account, presence: true
  validates :target_account, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :check_balance
  validate :different_accounts
  validate :has_amount

  private

  def self.create_transfer(source_account:, target_account:, amount:, category:, description:)
    ActiveRecord::Base.transaction do

      transaction = create!(
        source_account: source_account,
        target_account: target_account,
        amount: amount,
        category: category,
        description: description
      )

      source_account.update!(balance: source_account.balance - amount)
      target_account.update!(balance: target_account.balance + amount)

      Movement.create!(account: source_account, bivix_transaction: transaction, amount: -amount, movement_date: Time.now)
      Movement.create!(account: target_account, bivix_transaction: transaction, amount: amount, movement_date: Time.now)

      transaction 

    end
  end

  private

  def check_balance
    if source_account && !amount.nil? && source_account.balance < amount
      errors.add(:base, "The balance isn't enough for this transaction")
    end
  end

  def different_accounts
    if source_account.present? && target_account.present? && source_account.id == target_account.id
      errors.add(:base, "Source and target accounts must exist and must be different")
    end
  end

  def has_amount
    if amount.nil? || amount <= 0
      errors.add(:amount, "Amount must be greater than 0")
    end
  end
end