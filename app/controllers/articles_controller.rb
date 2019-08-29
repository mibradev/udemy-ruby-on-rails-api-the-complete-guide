class ArticlesController < ApplicationController
  def index
    render json: ArticleSerializer.new(Article.all)
  end
end
