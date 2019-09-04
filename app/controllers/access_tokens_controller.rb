class AccessTokensController < ApplicationController
  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform
    render json: serialize(authenticator.access_token), status: :created
  end

  def destroy
    authorize!
    current_user.access_token.destroy
  end
end
