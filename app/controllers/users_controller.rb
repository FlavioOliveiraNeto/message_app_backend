class UsersController < ApplicationController
    before_action :authenticate_request

    def index
        users = User.where.not(id: @current_user.id)
                    .joins("LEFT JOIN LATERAL (
                              SELECT messages.content AS last_message, messages.created_at AS last_message_time
                              FROM messages
                              WHERE (messages.sender_id = users.id AND messages.receiver_id = #{@current_user.id}) 
                                 OR (messages.receiver_id = users.id AND messages.sender_id = #{@current_user.id})
                              ORDER BY messages.created_at DESC
                              LIMIT 1
                            ) last_message_data ON true")
                    .select('users.*, last_message_data.last_message, last_message_data.last_message_time')
                    .order('last_message_data.last_message_time DESC NULLS LAST')
      
        render json: users
    end      

    def show
        user = User.find(params[:id])
        render json: user
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Usuário não encontrado' }, status: :not_found
    end
end
