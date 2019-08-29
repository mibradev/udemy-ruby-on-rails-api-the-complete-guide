class ArticleSerializer < ApplicationSerializer
  set_type :articles
  attributes :title, :content, :slug
end
