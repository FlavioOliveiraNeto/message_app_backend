class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    user = User.find_by(id: params[:user_id])
    
    if user
      token = JwtService.encode(user_id: user.id)
      render json: { token: token }
    else
      render json: { error: 'ID de usuário inválido' }, status: :unauthorized
    end
  end
end