FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence }
    article
    user
  end
end
