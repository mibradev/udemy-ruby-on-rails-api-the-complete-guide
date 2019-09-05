class CommentsController < ApplicationController
  before_action :set_article

  def index
    render json: serialize(
      @article.comments.page(params[:page]).per(params[:per_page])
    )
  end

  def create
    authorize!
    @comment = @article.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      render json: serialize(@comment), status: :created, location: @article
    else
      render json: serialize_errors(@comment), status: :unprocessable_entity
    end
  end

  private
    def set_article
      @article = Article.find(params[:article_id])
    end

    def comment_params
      params.require(:data).require(:attributes).permit(:content)
    end
end
