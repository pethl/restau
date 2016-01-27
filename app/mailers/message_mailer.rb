class MessageMailer < ApplicationMailer
  default from: 'contacthangfirebbq@gmail.com'

  def send_message(message)
    @message = message
     Rails.logger.debug("__________message: #{@message}")
    if @message
      mail(to: 'contacthangfirebbq@gmail.com', subject: "Website Enquiry: #{@message.subject}")
    end
  end
end
