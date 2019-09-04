Rails.application.routes.draw do
  post 'login', to: 'access_tokens#create'
  delete 'logout', to: 'access_tokens#destroy'
  resources :articles
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
