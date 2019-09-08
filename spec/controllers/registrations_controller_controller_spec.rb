require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  shared_examples_for "invalid request" do
    it "returns http unprocessable entity" do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "does not create a user" do
      expect { subject }.not_to change(User, :count)
    end

    it "returns error messages" do
      subject
      expect(response.parsed_body["errors"]).to eq([
        {
          "source" => { "pointer" => "/data/attributes/login" },
          "detail" => "can't be blank"
        },
        {
          "source" => { "pointer" => "/data/attributes/password" },
          "detail" => "can't be blank"
        }
      ])
    end
  end

  describe "POST #create" do
    context "without params" do
      subject { post :create }
      it_behaves_like "invalid request"
    end

    context "with invalid params" do
      let(:params) { { data: { attributes: { login: nil, password: nil } } } }
      subject { post :create, params: params }
      it_behaves_like "invalid request"
    end

    context "with invalid login" do
      let(:params) { { data: { attributes: { login: nil, password: "password" } } } }
      subject { post :create, params: params }

      it "return error messages" do
        subject
        expect(response.parsed_body["errors"]).to eq([{
          "source" => { "pointer" => "/data/attributes/login" },
          "detail" => "can't be blank"
        }])
      end
    end

    context "with invalid password" do
      let(:params) { { data: { attributes: { login: "login", password: nil } } } }
      subject { post :create, params: params }

      it "return error messages" do
        subject
        expect(response.parsed_body["errors"]).to eq([{
          "source" => { "pointer" => "/data/attributes/password" },
          "detail" => "can't be blank"
        }])
      end
    end

    context "with valid params" do
      let(:params) { { data: { attributes: { login: "login", password: "password" } } } }
      subject { post :create, params: params }

      it "returns http created" do
        subject
        expect(response).to have_http_status(:created)
      end

      it "creates a user" do
        expect(User.exists?(login: "login")).to be_falsey
        expect { subject }.to change(User, :count).by(1)
        expect(User.exists?(login: "login")).to be_truthy
      end

      it "returns serialized json" do
        subject
        expect(User.last).to match_jsonapi([:login, :name, :url, :avatar_url, :provider])
      end
    end
  end
end
