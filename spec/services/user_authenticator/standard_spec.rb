require 'rails_helper'

RSpec.describe UserAuthenticator::Standard, type: :service do
  describe "#perform" do
    let!(:user) { FactoryBot.create(:user, login: "mylogin", password: "mypassword") }
    subject { authenticator.perform }

    context "with invalid login" do
      let(:authenticator) { described_class.new("notmylogin", "mypassword") }

      it "raises an error" do
        expect { subject }.to raise_error(described_class::AuthenticationError)
        expect(authenticator.user).to be_nil
      end
    end

    context "with invalid password" do
      let(:authenticator) { described_class.new("mylogin", "notmypassword") }

      it "raises an error" do
        expect { subject }.to raise_error(described_class::AuthenticationError)
        expect(authenticator.user).to be_nil
      end
    end

    context "with valid login and password" do
      let(:authenticator) { described_class.new("mylogin", "mypassword") }

      it "sets user" do
        expect { subject }.not_to change { User.count }
        expect(authenticator.user).to eq(user)
      end
    end
  end
end
