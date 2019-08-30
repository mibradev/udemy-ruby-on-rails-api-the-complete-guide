class ArticlesController < ApplicationController
  def index
    render json: ArticleSerializer.new(Article.recent)
  end
end
