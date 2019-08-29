require 'rails_helper'

RSpec.describe ArticlesController, type: :routing do
  it "routes /articles to articles index" do
    expect(get: "/articles").to route_to("articles#index")
  end
end
