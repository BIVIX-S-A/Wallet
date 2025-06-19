require_relative '../spec_helper'

RSpec.describe User do

  context 'validations' do
    it 'requires an email' do
      user = User.new(name: "Test User", password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'requires a name' do
      user = User.new(email: "userfortestingpurposes#{rand(100000)}@test.com", password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'requires a password' do
      user = User.new(email: "userfortestingpurposes#{rand(100000)}@test.com", name: "Test User")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'validates email format' do
      user = User.new(email: "invalid_email", name: "Test User", password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it 'validates password length' do
      user = User.new(email: "userfortestingpurposes#{rand(100000)}@test.com", name: "Test User", password: '123')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it 'allows valid user creation' do
      user = User.new(email: "userfortestingpurposes#{rand(100000)}@test.com", name: "Test User", password: 'password')
      expect(user).to be_valid
    end

    it 'ensures email uniqueness' do
      user1 = User.create!(email: "userfortestingpurposes#{rand(100000)}@test.com", name: "Test User 1", password: 'password')
      user2 = User.new(email: user1.email, name: "Test User 2", password: 'password')
      expect(user2).not_to be_valid
      expect(user2.errors[:email]).to include("has already been taken")
    end

  end


end