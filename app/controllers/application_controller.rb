class ApplicationController < ActionController::API
  include Serializeable
  include Authenticatable
  include Authorizable
end
