require 'rails_helper'

shared_examples_for "unauthorized requests" do
  it "returns http unauthorized" do
    subject
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns error" do
    subject
    expect(response.parsed_body["errors"]).to include({
      "status" => "401",
      "source" => { "pointer" => "/code" },
      "title" =>  "Authentication code is invalid",
      "detail" => "You must provide valid code in order to exchange it for token."
    })
  end
end

shared_examples_for "forbidden requests" do
  it "returns http forbidden" do
    subject
    expect(response).to have_http_status(:forbidden)
  end

  it "returns http forbidden" do
    subject
    expect(response.parsed_body["errors"]).to include({
      "status" => "403",
      "source" => { "pointer" => "/headers/authorization" },
      "title" =>  "Not authorized",
      "detail" => "You have no right to access this resource."
    })
  end
end
