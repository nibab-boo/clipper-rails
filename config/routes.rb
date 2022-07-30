Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'

  get "/oauth/callback", to: "document_callbacks#oauth_callback"

  get "/oauth", to: "document_callbacks#oauth"


  get "/oauth2callback", to: "document_callbacks#set_google_drive_token"

  get "/files", to: "pages#files"
  get "/fetch_file/:id", to: "pages#fetch_file", as: "fetch_file"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
