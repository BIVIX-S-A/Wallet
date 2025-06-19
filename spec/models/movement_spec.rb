require_relative '../spec_helper'

RSpec.describe Movement do
  let(:user0) { User.create!(email: "userfortestingpurposes#{rand(10000)}@mail.com", name: "userfortestingpurposes#{rand(100000)}", password: "123456") }
  let(:account0) { Account.create!(user: user0, balance: 100.0) }
  let(:user1) { User.create!(email: "userfortestingpurposes#{rand(10000)}@mail.com", name: "userfortestingpurposes#{rand(100000)}", password: "123456") }
  let(:account1) { Account.create!(user: user1, balance: 50.0) }
  let(:transaction) do
    Transaction.create!(
      source_account: account0,
      target_account: account1,
      amount: 10.0
    )
  end

  it 'is valid with valid attributes' do
    movement = Movement.new(
      amount: 10.0,
      movement_date: Date.today,
      account: account0,
      bivix_transaction: transaction
    )
    expect(movement).to be_valid
  end

  it 'is not valid without amount' do
    movement = Movement.new(
      movement_date: Date.today,
      account: account0,
      bivix_transaction: transaction
    )
    expect(movement).not_to be_valid
  end

  it 'is not valid without account' do
    movement = Movement.new(
      amount: 10.0,
      movement_date: Date.today,
      bivix_transaction: transaction
    )
    expect(movement).not_to be_valid
  end

  it 'is not valid without transaction' do
    movement = Movement.new(
      amount: 10.0,
      movement_date: Date.today,
      account: account0
    )
    expect(movement).not_to be_valid
  end

  it 'belongs to an account and a transaction' do
    movement = Movement.create!(
      amount: 10.0,
      movement_date: Date.today,
      account: account0,
      bivix_transaction: transaction
    )
    expect(movement.account).to eq(account0)
    expect(movement.bivix_transaction).to eq(transaction)
  end

  it 'creates a movement when a transaction is created' do
    expect {
      Transaction.create!(
        source_account: account0,
        target_account: account1,
        amount: 10.0
      )
    }.to change { Movement.count }.by(2) # One for source and one for target account
  end
end