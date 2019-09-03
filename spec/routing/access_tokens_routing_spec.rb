require 'rails_helper'

RSpec.describe AccessTokensController, type: :routing do
  it "routes /login to access_tokens create" do
    expect(post: "/login").to route_to("access_tokens#create")
  end
end
