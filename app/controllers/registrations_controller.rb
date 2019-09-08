class RegistrationsController < ApplicationController
  def create
    user = User.new(registration_params.merge(provider: "standard"))

    if user.save
      render json: serialize(user, serializer: :user), status: :created
    else
      render json: serialize_errors(user), status: :unprocessable_entity
    end
  end

  private
    def registration_params
      params.dig(:data, :attributes)&.permit(:login, :password) ||
      ActionController::Parameters.new.permit
    end
end
