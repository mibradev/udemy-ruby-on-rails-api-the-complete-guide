require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  let(:user) { FactoryBot.create(:user, login: "mylogin", password: "mypassword") }

  describe "POST #create" do
    context "without auth data" do
      subject { post :create }
      it_behaves_like "unauthorized standard request"
    end

    context "with invalid login" do
      subject { post :create, params: { data: { attributes: { login: "notmylogin", password: "mypassword" } } } }
      before { user }
      it_behaves_like "unauthorized standard request"
    end

    context "with invalid password" do
      subject { post :create, params: { data: { attributes: { login: "mylogin", password: "notmypassword" } } } }
      before { user }
      it_behaves_like "unauthorized standard request"
    end

    context "with valid login and password" do
      subject { post :create, params: { data: { attributes: { login: "mylogin", password: "mypassword" } } } }
      before { user }

      it "returns serialized json" do
        subject
        expect(response).to have_http_status(:created)
        expect(response.parsed_body["data"]["attributes"]).to eq("token" => user.access_token.token)
      end
    end

    context "with invalid code" do
      subject { post :create, params: { code: "invalidcode" } }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(
          double("Sawyer::Resource", error: "bad_verification_code")
        )
      end

      it_behaves_like "unauthorized oauth request"
    end

    context "with valid code" do
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
        expect(response.parsed_body["data"]["attributes"]).to eq("token" => user.access_token.token)
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy }

    context "without authorization header" do
      it_behaves_like "forbidden request"
    end

    context "with invalid authorization header" do
      before { request.headers["authorization"] = "invalidtoken" }
      it_behaves_like "forbidden request"
    end

    context "with valid authorization header" do
      let(:user) { FactoryBot.create(:user) }
      let(:access_token) { user.create_access_token }

      before { request.headers["authorization"] = "Bearer #{access_token.token}" }

      it "returns http no content" do
        subject
        expect(response).to have_http_status(:no_content)
      end

      it "removes user's access token" do
        expect { subject }.to change{ AccessToken.count }.by(-1)
      end
    end
  end
end
