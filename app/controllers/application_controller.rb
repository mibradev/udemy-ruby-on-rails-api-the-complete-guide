class ApplicationController < ActionController::API
  include Serializeable
  include Authenticatable
end
