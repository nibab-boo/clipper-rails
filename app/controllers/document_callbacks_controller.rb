class DocumentCallbacksController < ApplicationController

  def oauth
    redirect_to(client.authorization_uri.to_s)

  end
  
  def oauth_callback
    auth_client = client
    auth_client.code = params['code']
    p "auth_client", auth_client

    token = auth_client.fetch_access_token!
    

    p "token", token
  end
  

  private

  def client
    Signet::OAuth2::Client.new(
      :authorization_uri => 'https://accounts.google.com/o/oauth2/auth',
      :token_credential_uri =>  'https://oauth2.googleapis.com/token',
      :client_id => "#{ENV['GOOGLE_CLIENT_ID']}",
      :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
      :scope => 'https://www.googleapis.com/auth/documents',
      :redirect_uri => 'http://localhost:3000/oauth/callback'
    )
  end

end