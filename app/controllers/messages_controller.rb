class MessagesController < ApplicationController
    before_action :authenticate_request
  
    def index
      messages = Message.where(sender_id: [@current_user.id, params[:user_id]])
                        .where(receiver_id: [@current_user.id, params[:user_id]])
                        .order(created_at: :asc)
  
      render json: messages
    end
  
    def create
      @message = Message.new(message_params)
      @message.sender_id = @current_user.id
      if @message.save
        render json: @message, status: :created
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def message_params
      params.require(:message).permit(:receiver_id, :content)
    end
end