require_relative '../spec_helper'

RSpec.describe Account do
  it 'validates presence of balance' do
    account = Account.new(balance: nil)
    expect(account).not_to be_valid
    expect(account.errors[:balance]).to include("can't be blank")
  end

  it 'validates numericality of balance' do
    account = Account.new(balance: 'not_a_number')
    expect(account).not_to be_valid
    expect(account.errors[:balance]).to include("is not a number")
  end

  it 'validates numericality of balance as greater than or equal to zero' do
    account = Account.new(balance: -10.0)
    expect(account).not_to be_valid
    expect(account.errors[:balance]).to include("must be greater than or equal to 0")
  end

  it 'validates presence of user' do
    account = Account.new(user: nil)
    expect(account).not_to be_valid
    expect(account.errors[:user]).to include("can't be blank")
  end
end