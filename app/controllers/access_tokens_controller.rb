class AccessTokensController < ApplicationController
  def create
    UserAuthenticator.new(params[:code]).perform
  end
end
