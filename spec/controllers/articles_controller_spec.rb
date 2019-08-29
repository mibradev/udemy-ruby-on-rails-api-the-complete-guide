require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns serialized json" do
      article = FactoryBot.create(:article)
      get :index
      data = JSON.parse(response.body)["data"]
      expect(data[0]["id"]).to eq(article.id.to_s)
      expect(data[0]["type"]).to eq(article.class.name.downcase.pluralize)
      expect(data[0]["attributes"]["title"]).to eq(article.title)
      expect(data[0]["attributes"]["content"]).to eq(article.content)
      expect(data[0]["attributes"]["slug"]).to eq(article.slug)
    end
  end
end
