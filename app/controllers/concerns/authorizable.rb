module Authorizable
  extend ActiveSupport::Concern

  class AuthorizationError < StandardError
  end

  included do
    rescue_from AuthorizationError, with: :authorization_error
  end

  private
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
