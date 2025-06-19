require_relative '../spec_helper'

RSpec.describe Transaction do
  let(:user1) { User.create!(email: "userfortestingpurposes#{rand(100000)}@test.com", name: "userfortestingpurposes#{rand(100000)}", password: '123456') }
  let(:user2) { User.create!(email: "userfortestingpurposes#{rand(100000)}@test.com", name: "userfortestingpurposes#{rand(100000)}", password: '123456') }
  let(:source_account) { Account.create!(balance: 100.0, user: user1) }
  let(:target_account) { Account.create!(balance: 50.0, user: user2) }

  context 'validations' do
    it 'doesn\'t allow transactions if there\'s no enough balance' do
      transaction = Transaction.new(
        source_account: source_account,
        target_account: target_account,
        amount: 150.0
      )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:base]).to include("The balance isn't enough for this transaction")
    end

    it 'does allow transactions if there\'s enough balance' do
      transaction = Transaction.new(
        source_account: source_account,
        target_account: target_account,
        amount: 50.0
      )
      expect(transaction).to be_valid
    end

    it 'doesn\'t allow transactions with negative amount' do
      transaction = Transaction.new(
        source_account: source_account,
        target_account: target_account,
        amount: -10.0
      )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include("must be greater than 0")
    end

    it 'doesn\'t allow transactions with zero as amount' do
      transaction = Transaction.new(
        source_account: source_account,
        target_account: target_account,
        amount: 0.0
      )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include("must be greater than 0")
    end

    it 'doesn\'t allow transactions without source account' do
      transaction = Transaction.new(
        target_account: target_account,
        amount: 50.0
      )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:source_account]).to include("can't be blank")
    end

    it 'doesn\'t allow transactions without target account' do
      transaction = Transaction.new(
        source_account: source_account,
        amount: 50.0
      )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:target_account]).to include("can't be blank")
    end
    
    it 'doesn\'t allow transactions without amount' do
      transaction = Transaction.new(
        source_account: source_account,
        target_account: target_account
      )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount]).to include("Amount must be greater than 0")
    end

    it 'doesn\'t allow transactions with equal target and source accounts' do
      transaction = Transaction.new(
        source_account: source_account,
        target_account: source_account,
        amount: 10.0
      )
      expect(transaction).not_to be_valid
      expect(transaction.errors[:base]).to include("Source and target accounts must exist and must be different")
    end

    it 'keeps the balance of both accounts before and after the transaction' do
      balance_before = source_account.balance + target_account.balance
      
      transaction = Transaction.new(
        source_account: source_account,
        target_account: target_account,
        amount: 20.0
      )

      balance_after = source_account.balance + target_account.balance
      expect(balance_after).to eq(balance_before)
    end
  end

  context 'after create callback' do
    it 'debits and credits balances correctly' do
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
