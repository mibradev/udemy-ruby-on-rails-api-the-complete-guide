require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid" do
      expect(FactoryBot.build(:user)).to be_valid
    end

    it "requires login" do
      user = FactoryBot.build(:user, login: nil)
      expect(user).not_to be_valid
      expect(user.errors.messages[:login]).to include("can't be blank")
    end

    it "requires unique login" do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.build(:user, login: user1.login)
      expect(user2).not_to be_valid
      expect(user2.errors.messages[:login]).to include("has already been taken")
    end

    it "requires provider" do
      user = FactoryBot.build(:user, provider: nil)
      expect(user).not_to be_valid
      expect(user.errors.messages[:provider]).to include("can't be blank")
    end
  end
end
