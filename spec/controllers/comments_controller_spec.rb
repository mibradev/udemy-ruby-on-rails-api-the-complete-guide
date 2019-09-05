require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:valid_attributes) { { data: { attributes: FactoryBot.attributes_for(:comment) } } }
  let(:invalid_attributes) { { data: { attributes: { content: nil } } } }
  let(:article) { FactoryBot.create(:article) }
  let(:user) { FactoryBot.create(:user) }
  let(:access_token) { user.create_access_token }
  let(:comment) { FactoryBot.create(:comment, article: article, user: user) }

  describe "GET #index" do
    subject { get :index, params: { article_id: article.id } }

    it "returns a success response" do
      subject
      expect(response).to have_http_status(:ok)
    end

    it "returns only article's comments" do
      comment
      FactoryBot.create(:comment)
      subject
      expect(response.parsed_body["data"].length).to eq(1)
      expect(response.parsed_body["data"].first["id"]).to eq(comment.id.to_s)
    end

    it "returns paginated comments" do
      comments = FactoryBot.create_list(:comment, 3, article: article)
      get :index, params: { article_id: article.id, page: 2, per_page: 1 }
      expect(response.parsed_body["data"].length).to eq(1)
      expect(response.parsed_body["data"].first["id"]).to eq(comments.second.id.to_s)
    end

    it "returns serialized json" do
      comment
      subject
      expect(comment).to match_jsonapi(:content)
    end

    it "have related objects" do
      comment
      subject
      relationships = response.parsed_body["data"].first["relationships"]
      expect(relationships["article"]["data"]["id"]).to eq(article.id.to_s)
      expect(relationships["user"]["data"]["id"]).to eq(user.id.to_s)
    end
  end

  describe "POST #create" do
    context "without authorization" do
      subject { post :create, params: { article_id: article.id } }
      it_behaves_like "forbidden requests"
    end

    context "with authorization" do
      before do
        request.headers["authorization"] = "Bearer #{access_token.token}"
      end

      context "with valid params" do
        subject { post :create, params: valid_attributes.merge(article_id: article.id) }

        it "creates a new comment" do
          expect { subject }.to change(Comment, :count).by(1)
        end

        it "renders a JSON response with the new comment" do
          subject
          expect(response).to have_http_status(:created)
          expect(response.parsed_body["data"]["attributes"]).to eq(valid_attributes[:data][:attributes].stringify_keys)
        end
      end

      context "with invalid params" do
        subject { post :create, params: invalid_attributes.merge(article_id: article.id) }

        it "renders a JSON response with errors for the new comment" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq("application/json; charset=utf-8")
          expect(response.parsed_body["errors"]).to include({
            "source" => { "pointer" => "/data/attributes/content" },
            "detail" => "can't be blank"
          })
        end
      end
    end
  end
end
