class MessagesController < ApplicationController
  include Rails.application.routes.url_helpers
  
  before_action :authenticate_request

  def index
    messages = Message.where(sender_id: [@current_user.id, params[:user_id]])
                      .where(receiver_id: [@current_user.id, params[:user_id]])
                      .order(created_at: :asc)
                      .page(params[:page]).per(10)
  
    render json: {
      messages: messages.map { |msg| serialize_message(msg) },
      total_pages: messages.total_pages,
      current_page: messages.current_page
    }
  end

  def create
    @message = Message.new(message_params)
    @message.sender_id = @current_user.id
  
    if @message.save
      serialized_message = serialize_message(@message)
      ActionCable.server.broadcast("messages_#{@message.receiver_id}", serialized_message)
  
      ProcessMessageJob.perform_later(@message.id)
  
      render json: serialized_message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id, :content, :attachment)
  end

  def serialize_message(message)
    {
      id: message.id,
      sender_id: message.sender_id,
      receiver_id: message.receiver_id,
      content: message.content,
      created_at: message.created_at,
      attachment_url: message.attachment.attached? ? url_for(message.attachment) : nil,
      attachment_content_type: message.attachment.attached? ? message.attachment.content_type : nil
    }
  end  
end