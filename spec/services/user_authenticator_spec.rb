require 'rails_helper'

RSpec.describe UserAuthenticator, type: :service do
  let(:user) { FactoryBot.create(:user, password: Faker::Internet.password) }

  shared_examples_for "authenticator" do
    it "sets access token" do
      expect(authenticator.authenticator).to receive(:perform).and_return(true)
      expect(authenticator.authenticator).to receive(:user).at_least(:once).and_return(user)
      expect { authenticator.perform }.to change { AccessToken.count }.by(1)
      expect(authenticator.access_token).to be_present
    end
  end

  context "with code" do
    let(:authenticator) { described_class.new(code: "code") }

    it_behaves_like "authenticator"

    it "initializes oauth authenticator" do
      expect(authenticator.authenticator).to be_a(UserAuthenticator::Oauth)
    end
  end

  context "with login and password" do
    let(:authenticator) { described_class.new(login: "login", password: "password") }

    it_behaves_like "authenticator"

    it "initializes standard authenticator" do
      expect(authenticator.authenticator).to be_a(UserAuthenticator::Standard)
    end
  end
end
