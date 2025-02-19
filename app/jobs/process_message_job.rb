class ProcessMessageJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find(message_id)
    send_email_notification(message)
  end

  private

  def send_email_notification(message)
    recipient = User.find(message.receiver_id)
    sender = User.find(message.sender_id)

    UserMailer.new_message_notification(recipient, sender, message).deliver_now
  end
end