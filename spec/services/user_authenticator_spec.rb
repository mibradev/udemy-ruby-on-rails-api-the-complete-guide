require 'rails_helper'

RSpec.describe UserAuthenticator, type: :service do
  describe "#perform" do
    let(:authenticator) { described_class.new("code") }
    subject { authenticator.perform }

    context "when code is incorrect" do
      let(:error) { double("Sawyer::Resource", error: "bad_verification_code") }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(error)
      end

      it "should raise an error" do
        expect { subject }.to raise_error(described_class::AuthenticationError)
        expect(authenticator.user).to be_nil
      end
    end

    context "when code is correct" do
      let(:user_data) { FactoryBot.attributes_for(:user).slice(:login, :name, :url, :avatar_url) }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return("validaccesstoken")
        allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
      end

      it "should save the user if does not exist" do
        expect { subject }.to change { User.count }.by(1)
        expect(User.last.login).to eq(authenticator.user.login)
      end

      it "should reuse already registered user" do
        user = FactoryBot.create(:user, user_data.merge(provider: "github"))
        expect { subject }.not_to change { User.count }
        expect(authenticator.user).to eq(user)
      end

      it "should set access token" do
        expect { subject }.to change { AccessToken.count }.by(1)
        expect(authenticator.access_token).to be_present
      end
    end
  end
end
