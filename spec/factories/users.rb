FactoryBot.define do
  factory :user do
    login { Faker::Internet.unique.username(separators: "") }
    name { Faker::Name.name }
    url { Faker::Internet.url(host: "github.com", path: "/#{login}") }
    avatar_url { Faker::Avatar.image }
    provider { "github" }
  end
end
