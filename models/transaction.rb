class Transaction < ActiveREcords::Base
  belongs_to :source_account, class_name: 'Account'
  belongs_to :target_account, class_name: 'Account'

  after_create :transfer_balance

  private

  def transfer_balance
    #Making all in a db transaction for avoid inconsistencies
    ActiveREcord::Base.transaction do
      source_account.balance -= amount
      source_account.save!

      target_account.balance +=amount
      target_account.save!
    end
  end
end
