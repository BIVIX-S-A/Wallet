require_relative '../spec_helper'

RSpec.describe Transaction do
  let(:user1) { User.create!(email: "user#{rand(1000)}@test.com}", name: "User#{rand(1000)}", password: '123456') }
  let(:user2) { User.create!(email: "user#{rand(1000)}@test.com}", name: "User#{rand(1000)}", password: '123456') }
  let(:source_account) { Account.create!(balance: 100.0, user: user1) }
  let(:target_account) { Account.create!(balance: 50.0, user: user2) }

  context 'validations' do
    it 'no permite crear transacción si no hay saldo suficiente' do
      transaction = Transaction.new(
        source_account: source_account,
        target_account: target_account,
        amount: 150.0
      )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:base]).to include("The balance isn't enough for this transaction")
    end

    it 'permite crear transacción si hay saldo suficiente' do
      transaction = Transaction.new(
        source_account: source_account,
        target_account: target_account,
        amount: 50.0
      )
      expect(transaction).to be_valid
    end
  end

  context 'after create callback' do
    it 'debita y acredita los balances correctamente' do
      transaction = Transaction.create!(
        source_account: source_account,
        target_account: target_account,
        amount: 40.0
      )

      expect(source_account.reload.balance).to eq(60.0)
      expect(target_account.reload.balance).to eq(90.0)
    end
  end
end
