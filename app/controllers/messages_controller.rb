class MessagesController < ApplicationController
  before_action :authenticate_request

  def index
    messages = Message.where(sender_id: [@current_user.id, params[:user_id]])
                      .where(receiver_id: [@current_user.id, params[:user_id]])
                      .order(created_at: :asc)
                      .page(params[:page]).per(10)

    render json: {
      messages: messages,
      total_pages: messages.total_pages,
      current_page: messages.current_page
    }
  end

  def create
    @message = Message.new(message_params)
    @message.sender_id = @current_user.id

    if @message.save
      ActionCable.server.broadcast("messages_#{@message.receiver_id}", @message)

      #ProcessMessageJob.perform_later(@message.id)

      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id, :content, :attachment)
  end
end