class DocumentCallbacksController < ApplicationController

  # def oauth
  #   redirect_to(client.authorization_uri.to_s)

  # end
  
  def oauth_callback
    auth_client = client
    auth_client.code = params['code']
    p "auth_client", auth_client

    token = auth_client.fetch_access_token!
    
    p "token", token
    service = Google::Apis::DriveV3::new
    service.authorization = token['access_token']

    document_id = "1k_SFjs44PH7oPxeEnHi3PnXwsAje29W_FH1SL0PT_YE"

    # It is returning the Document. But We might need to use Google Drive instead of this.
    @document = service.get_document document_id, fields: "title, content, body"
    puts "The title", document.title
    byebug

  end

  def oauth
    redirect_to($drive.authorization_url(request, current_user.id))
  end
  
  def set_google_drive_token
    if request['code'] == nil
      redirect_to($drive.authorization_url(request, current_user.id))
    else
      @credentials = $drive.from_code(request['code'], current_user.id)
      # $drive.save_credentials(current_user.id)
      $drive.set_authorization

      redirect_to('/')
    end
  end

  private

  def client
    Signet::OAuth2::Client.new(
      :authorization_uri => 'https://accounts.google.com/o/oauth2/auth',
      :token_credential_uri =>  'https://oauth2.googleapis.com/token',
      :client_id => "#{ENV['GOOGLE_CLIENT_ID']}",
      :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
      :scope => 'https://www.googleapis.com/auth/drive, https://www.googleapis.com/auth/drive.file',
      :redirect_uri => 'http://localhost:3000/oauth/callback'
    )
  end

end