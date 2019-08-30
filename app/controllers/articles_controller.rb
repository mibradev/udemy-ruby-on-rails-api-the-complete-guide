class ArticlesController < ApplicationController
  def index
    render json: ArticleSerializer.new(
      Article.recent.page(params[:page]).per(params[:per_page])
    )
  end
end
