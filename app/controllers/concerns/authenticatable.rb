module Authenticatable
  extend ActiveSupport::Concern

  included do
    rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
  end

  private
    def authentication_error
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
end
