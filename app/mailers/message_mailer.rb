class MessageMailer < ApplicationMailer

  default from: 'message@miterra.com'


  def new_message(message)
    @message = message
    @user = @message.to_user
    mail( :to => @message.to_user.email,
          :subject => "New Message from #{@message.from_name}" )
  end
end
