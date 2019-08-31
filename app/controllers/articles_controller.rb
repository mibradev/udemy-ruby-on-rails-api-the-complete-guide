class ArticlesController < ApplicationController
  def index
    render json: serialize(Article.recent.page(params[:page]).per(params[:per_page]))
  end

  def show
    render json: serialize(Article.find(params[:id]))
  end
end
