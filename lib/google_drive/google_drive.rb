require 'google/apis/drive_v3'
require 'googleauth/web_user_authorizer'

require 'googleauth/stores/redis_token_store'
require 'redis'

class MyDrive
  OOB_URI = "localhost:3000/oauth2callback"
  attr_writer :authorizer, :drive, :redirect_uri, :credentials

  def initialize
    # client_id = Google::Auth::ClientId.from_file('/path/to/client_secrets.json')
    client_id = ENV["GOOGLE_CLIENT_ID"]
    scope = ['https://www.googleapis.com/auth/drive']
    # token_store = Google::Auth::Stores::RedisTokenStore.new(redis: $redis)
    token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
    # @authorizer = Google::Auth::UserAuthorizer.new(
    # client_id, scope, token_store)
    authorizer = Google::Auth::WebUserAuthorizer.new(
    client_id, scope, token_store, '/oauth2callback')
    # user_id = 'darazone'
    # @credentials = @authorizer.get_credentials(user_id)
    # @drive = Google::Apis::DriveV3::DriveService.new
    # @drive.authorization = @credentials

  end

  def authorization_url(request, user_id)
    # @authorizer.get_authorization_url(base_url: OOB_URI)
    @authorizer.get_authorization_url(login_hint: user_id, request: request)
  end

  def get_credentials
    # @credentials
    @credentials = authorizer.get_credentials(user_id, request)
  end

  def set_authorization
    @drive.authorization = @credentials
  end

  def get_drive
    @drive
  end

  def save_credentials(code, user_id)
    @credentials = @authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code)
    @drive.authorization = @credentials
  end

  def list_files(options = {})
    @drive.list_files(options: options)
  end

  def upload(file, options = {})
    # file[:parent_ids] = [{id: 'id'}]
    file_obj = Google::Apis::DriveV2::File.new({
      title: file[:title],
      parents: file[:parent_ids]
    })
    f = @drive.insert_file(file_obj, upload_source: file[:path])
    f.id
    rescue
      nil
  end

  def delete(id, options = {})
    @drive.delete_file(id)
  end

  def update(id, file, options = {})
    @drive.patch_file(id, file)
  end

  def get(id, options = {})
    @drive.get_file(id)
  end

  def list_children_files(parent_id, options = {})
    @drive.list_children(parent_id, options: options).items
  end
end

