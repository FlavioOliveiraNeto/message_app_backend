class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request
  
    def authenticate
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        token = JwtService.encode(user_id: user.id)
        render json: { token: token }
      else
        render json: { error: 'Credenciais inválidas' }, status: :unauthorized
      end
    end
end