class ArticlesController < ApplicationController
  def index
    render json: serialize(Article.recent.page(params[:page]).per(params[:per_page]))
  end

  def show
    render json: serialize(Article.find(params[:id]))
  end

  def create
    authorize!
    article = current_user.articles.build(article_params)

    if article.save
      render json: serialize(article), status: :created
    else
      render json: serialize_errors(article), status: :unprocessable_entity
    end
  end

  def update
    authorize!
    article = current_user.articles.find_by_id(params[:id])

    if article.nil?
      authorization_error
    elsif article.update(article_params)
      render json: serialize(article)
    else
      render json: serialize_errors(article), status: :unprocessable_entity
    end
  end

  def destroy
    authorize!
    article = current_user.articles.find_by_id(params[:id])

    if article.nil?
      authorization_error
    else article.destroy
      head :no_content
    end
  end

  private
    def article_params
      params.require(:data).require(:attributes).permit(:title, :content, :slug)
    end
end
