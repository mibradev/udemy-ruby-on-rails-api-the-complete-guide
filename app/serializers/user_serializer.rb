class UserSerializer < ApplicationSerializer
  set_type :users
  attributes :login, :name, :url, :avatar_url, :provider
end
