require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe "GET #index" do
    it "returns http ok" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["data"]).to eq([])
    end

    it "returns serialized json" do
      articles = FactoryBot.create_list(:article, 2)
      get :index
      expect(articles).to match_jsonapi([:title, :content, :slug])
    end
  end
end
