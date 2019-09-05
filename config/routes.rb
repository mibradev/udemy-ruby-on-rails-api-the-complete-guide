Rails.application.routes.draw do
  resources :articles do
    resources :comments, only: [:index, :create]
  end

  post 'login', to: 'access_tokens#create'
  delete 'logout', to: 'access_tokens#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
