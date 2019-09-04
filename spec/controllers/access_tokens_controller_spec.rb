require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  describe "POST #create" do
    shared_examples_for "unauthorized requests" do
      it "returns http unauthorized" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error" do
        subject
        expect(response.parsed_body["errors"]).to include({
          "status" => "401",
          "source" => { "pointer" => "/code" },
          "title" =>  "Authentication code is invalid",
          "detail" => "You must provide valid code in order to exchange it for token."
        })
      end
    end

    context "no code" do
      subject { post :create }
      it_behaves_like "unauthorized requests"
    end

    context "invalid code" do
      subject { post :create, params: { code: "invalidcode" } }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(
          double("Sawyer::Resource", error: "bad_verification_code")
        )
      end

      it_behaves_like "unauthorized requests"
    end

    context "successful request" do
      subject { post :create, params: { code: "validcode" } }
      let(:user_data) { FactoryBot.attributes_for(:user).slice(:login, :name, :url, :avatar_url) }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return("validaccesstoken")
        allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
      end

      it "returns http created" do
        subject
        expect(response).to have_http_status(:created)
      end

      it "returns serialized json" do
        expect { subject }.to change { User.count }.by(1)
        user = User.find_by_login(user_data[:login])
        expect(response.parsed_body["data"]["attributes"]).to eq( { "token" => user.access_token.token } )
      end
    end
  end
end
