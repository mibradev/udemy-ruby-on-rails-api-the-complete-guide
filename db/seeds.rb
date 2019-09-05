# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = []

2.times do |i|
  user = User.new
  user.login = Faker::Internet.unique.username(separators: "")
  user.name = Faker::Name.name
  user.url = Faker::Internet.url(host: "github.com", path: "/#{user.login}")
  user.avatar_url = Faker::Avatar.image
  user.provider = "github"
  user.save!
  users << user
end

(1..100).each do |i|
  user = users.sample
  article = user.articles.create!(
    title: "Article title #{i}",
    content: "Article content #{i}",
    slug: "article-title-#{i}"
  )
  3.times { article.comments.create!(content: Faker::Lorem.sentence, user: user) if i.even? }
end
