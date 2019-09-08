require 'rails_helper'

RSpec.describe UserAuthenticator::Oauth, type: :service do
  describe "#perform" do
    let(:authenticator) { described_class.new("code") }
    subject { authenticator.perform }

    context "with invalid code" do
      let(:error) { double("Sawyer::Resource", error: "bad_verification_code") }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(error)
      end

      it "raises an error" do
        expect { subject }.to raise_error(described_class::AuthenticationError)
        expect(authenticator.user).to be_nil
      end
    end

    context "with valid code" do
      let(:user_data) { FactoryBot.attributes_for(:user).slice(:login, :name, :url, :avatar_url) }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return("validaccesstoken")
        allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
      end

      it "saves the user if does not exist" do
        expect { subject }.to change { User.count }.by(1)
        expect(User.last.login).to eq(authenticator.user.login)
      end

      it "reuses already registered user" do
        user = FactoryBot.create(:user, user_data.merge(provider: "github"))
        expect { subject }.not_to change { User.count }
        expect(authenticator.user).to eq(user)
      end
    end
  end
end
