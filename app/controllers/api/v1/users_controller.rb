class Api::V1::UsersController < ActionController::API
  acts_as_token_authentication_handler_for User, only: [:index, :show]

  def login
    render json: { login: "success"}, status: 200
  end

end