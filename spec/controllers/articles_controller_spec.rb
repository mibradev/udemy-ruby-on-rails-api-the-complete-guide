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

    it "returns sorted articles" do
      articles = FactoryBot.create_list(:article, 2)
      get :index
      data = response.parsed_body["data"]
      expect(data.first["id"]).to eq(articles.last.id.to_s)
      expect(data.last["id"]).to eq(articles.first.id.to_s)
    end

    it "returns paginated articles" do
      articles = FactoryBot.create_list(:article, 3)
      get :index, params: { page: 2, per_page: 1 }
      data = response.parsed_body["data"]
      expect(data.size).to eq(1)
      expect(data.first["id"]).to eq(articles.second.id.to_s)
    end
  end
end
