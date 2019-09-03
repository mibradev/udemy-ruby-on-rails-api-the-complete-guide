Rails.application.routes.draw do
  post 'login', to: 'access_tokens#create'
  resources :articles, only: [:index, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
