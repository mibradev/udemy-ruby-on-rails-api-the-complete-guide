class AccessTokensController < ApplicationController
  def create
    authenticator = UserAuthenticator.new(authentication_params)
    authenticator.perform
    render json: serialize(authenticator.access_token), status: :created
  end

  def destroy
    authorize!
    current_user.access_token.destroy
  end

  private
    def authentication_params
      (
        params.dig(:data, :attributes)&.permit(:login, :password) ||
        params.permit(:code)
      ).to_h.symbolize_keys
    end
end
