module Authorizable
  extend ActiveSupport::Concern

  class AuthorizationError < StandardError
  end

  included do
    rescue_from AuthorizationError, with: :authorization_error
  end

  private
    def authorize!
      raise AuthorizationError unless current_user
    end

    def current_user
      @current_user = access_token&.user
    end

    def access_token
      @access_token = AccessToken.find_by_token(
        request.authorization&.gsub(/\ABearer\s/, "")
      )
    end

    def authorization_error
      render json: {
        errors: [
          {
            status: "403",
            source: { "pointer": "/headers/authorization" },
            title:  "Not authorized",
            detail: "You have no right to access this resource."
          }
        ]
      }, status: :forbidden
    end
end
