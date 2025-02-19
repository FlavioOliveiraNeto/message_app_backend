class UserMailer < ApplicationMailer
    default from: 'teste@messageapp.com'
  
    def new_message_notification(recipient, sender, message)
      @recipient = recipient
      @sender = sender
      @message = message
  
      mail(to: @recipient.email, subject: 'Você recebeu um novo email!')
    end
end