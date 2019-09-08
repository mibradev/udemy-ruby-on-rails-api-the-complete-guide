require 'rails_helper'

RSpec.describe RegistrationsController, type: :routing do
  it "routes /sign_up to registrations create" do
    expect(post: "/sign_up").to route_to("registrations#create")
  end
end
