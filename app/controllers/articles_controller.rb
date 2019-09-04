class ArticlesController < ApplicationController
  def index
    render json: serialize(Article.recent.page(params[:page]).per(params[:per_page]))
  end

  def show
    render json: serialize(Article.find(params[:id]))
  end

  def create
    authorize!
    article = Article.new(article_params)

    if article.save
      render json: serialize(article), status: :created
    else
      render json: serialize_errors(article), status: :unprocessable_entity
    end
  end

  private
    def article_params
      params.require(:data).require(:attributes).permit(:title, :content, :slug)
    end
end
