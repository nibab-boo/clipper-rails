Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'

  get "/oauth/callback", to: "document_callbacks#oauth_callback"

  get "/oauth", to: "document_callbacks#oauth"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
