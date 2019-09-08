module Authenticatable
  extend ActiveSupport::Concern

  included do
    rescue_from UserAuthenticator::Oauth::AuthenticationError, with: :authentication_oauth_error
    rescue_from UserAuthenticator::Standard::AuthenticationError, with: :authentication_standard_error
  end

  private
    def authentication_oauth_error
      render json: {
        errors: [
          {
            status: "401",
            source: { "pointer": "/code" },
            title:  "Authentication code is invalid",
            detail: "You must provide valid code in order to exchange it for token."
          }
        ]
      }, status: :unauthorized
    end

    def authentication_standard_error
      render json: {
        errors: [
          {
            status: "401",
            source: { "pointer": "/data/attributes/password" },
            title:  "Invalid login or password",
            detail: "You must provide valid credentials in order to exchange them for token."
          }
        ]
      }, status: :unauthorized
    end
end
