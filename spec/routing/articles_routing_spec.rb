require 'rails_helper'

RSpec.describe ArticlesController, type: :routing do
  it "routes /articles to articles index" do
    expect(get: "/articles").to route_to("articles#index")
  end

  it "routes /articles/:id to articles show" do
    expect(get: "/articles/1").to route_to("articles#show", id: "1")
  end
end
