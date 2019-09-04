require 'rails_helper'

RSpec.describe ArticlesController, type: :routing do
  it "routes /articles to articles index" do
    expect(get: "/articles").to route_to("articles#index")
  end

  it "routes /articles/:id to articles show" do
    expect(get: "/articles/1").to route_to("articles#show", id: "1")
  end

  it "routes /articles to articles create" do
    expect(post: "/articles").to route_to("articles#create")
  end

  it "routes /articles/:id to articles update" do
    expect(patch: "/articles/1").to route_to("articles#update", id: "1")
    expect(put: "/articles/1").to route_to("articles#update", id: "1")
  end

  it "routes /articles/:id to articles destroy" do
    expect(delete: "/articles/1").to route_to("articles#destroy", id: "1")
  end
end
