class ApplicationController < ActionController::API
    before_action :authenticate_request
  
    private
  
    def authenticate_request
      token = request.headers['Authorization']&.split(' ')&.last
      decoded = JwtService.decode(token)
      @current_user = User.find(decoded[:user_id]) if decoded
      render json: { error: 'Não autorizado' }, status: :unauthorized unless @current_user
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Token inválido' }, status: :unauthorized
    end
end