class ArticlesController < ApplicationController
  include SerializerOptions

  def index
    articles = Article.recent.page(params[:page]).per(params[:per_page])
    options = { links: serializer_links(articles) }
    render json: ArticleSerializer.new(articles, options)
  end
end
