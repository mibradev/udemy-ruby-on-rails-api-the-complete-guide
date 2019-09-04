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
      links = response.parsed_body["links"]
      expect(data.size).to eq(1)
      expect(data.first["id"]).to eq(articles.second.id.to_s)
      expect(links["self"]).to eq(articles_path(page: 2, per_page: 1))
      expect(links["first"]).to eq(articles_path(per_page: 1))
      expect(links["next"]).to eq(articles_path(page: 3, per_page: 1))
      expect(links["previous"]).to eq(articles_path(page: 1, per_page: 1))
      expect(links["last"]).to eq(articles_path(page: 3, per_page: 1))
    end
  end

  describe "GET #show" do
    let(:article) { FactoryBot.create :article }
    subject { get :show, params: { id: article.id } }

    it "returns http ok" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "returns serialized json" do
      subject
      data = response.parsed_body["data"]
      expect(article).to match_jsonapi([:title, :content, :slug])
    end
  end

  describe "POST #create" do
    subject { post :create }

    context "no code" do
      it_behaves_like "forbidden requests"
    end

    context "invalid code" do
      before { request.headers["authorization"] = "invalidcode" }
      it_behaves_like "forbidden requests"
    end

    context "authorized" do
      let(:access_token) { FactoryBot.create(:access_token) }
      subject { post :create, params: { data: { attributes: { title: "", content: "" } } } }

      before do
        request.headers["authorization"] = "Bearer #{access_token.token}"
      end

      context "invalid parameter" do
        it "returns http unprocessable entity" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns serialized json" do
          subject
          expect(response.parsed_body["errors"]).to include(
            {
              "source" => { "pointer" => "/data/attributes/title" },
              "detail" => "can't be blank"
            },
            {
              "source" => { "pointer" => "/data/attributes/content" },
              "detail" => "can't be blank"
            },
            {
              "source" => { "pointer" => "/data/attributes/slug" },
              "detail" => "can't be blank"
            }
          )
        end
      end

      context "successful request" do
        let(:valid_attributes) do
          { "data" => { "attributes" => FactoryBot.attributes_for(:article).stringify_keys } }
        end

        subject do
          post :create, params: valid_attributes
        end

        it "returns http created" do
          subject
          expect(response).to have_http_status(:created)
        end

        it "returns serialized json" do
          subject
          expect(response.parsed_body["data"]["attributes"]).to include(valid_attributes["data"]["attributes"])
        end

        it "creates article" do
          expect { subject }.to change { Article.count }.by(1)
        end
      end
    end
  end

  describe "PATCH #update" do
    let(:article) { FactoryBot.create(:article) }
    subject { patch :update, params: { id: article.id } }

    context "no code" do
      it_behaves_like "forbidden requests"
    end

    context "invalid code" do
      before { request.headers["authorization"] = "invalidcode" }
      it_behaves_like "forbidden requests"
    end

    context "authorized" do
      let(:access_token) { FactoryBot.create(:access_token) }
      subject { patch :update, params: { id: article.id, data: { attributes: { title: "", content: "" } } } }

      before do
        request.headers["authorization"] = "Bearer #{access_token.token}"
      end

      context "invalid parameter" do
        it "returns http unprocessable entity" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns serialized json" do
          subject
          expect(response.parsed_body["errors"]).to include(
            {
              "source" => { "pointer" => "/data/attributes/title" },
              "detail" => "can't be blank"
            },
            {
              "source" => { "pointer" => "/data/attributes/content" },
              "detail" => "can't be blank"
            }
          )
        end
      end

      context "successful request" do
        let(:valid_attributes) do
          { id: article.id, "data" => { "attributes" => FactoryBot.attributes_for(:article).stringify_keys } }
        end

        subject do
          patch :update, params: valid_attributes
        end

        it "returns http created" do
          subject
          expect(response).to have_http_status(:ok)
        end

        it "returns serialized json" do
          subject
          expect(response.parsed_body["data"]["attributes"]).to include(valid_attributes["data"]["attributes"])
        end

        it "updates article" do
          subject
          expect(article.reload.title).to eq(valid_attributes["data"]["attributes"]["title"])
        end
      end
    end
  end
end
