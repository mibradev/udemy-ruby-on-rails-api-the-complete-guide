require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe "validations" do
    subject { FactoryBot.build(:access_token) }

    it "is valid" do
      expect(subject).to be_valid
    end

    it "has user" do
      subject.user = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages[:user]).to include("must exist")
    end
  end

  describe "#new" do
    it "has token" do
      expect(AccessToken.new.token).to be_present
    end

    it "has unique token" do
      user = FactoryBot.create(:user)
      expect { user.create_access_token }.to change { AccessToken.count }.by(1)
      expect(user.build_access_token).to be_valid
    end

    it "generates token once" do
      user = FactoryBot.create(:user)
      access_token = user.create_access_token
      expect(access_token.token).to eq(access_token.reload.token)
    end
  end
end
