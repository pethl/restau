class MessageMailer < ApplicationMailer
  default from: 'hangfirebarry@gmail.com'

  def send_message(message)
    @message = message
     if @message
      mail(to: 'hangfirebarry@gmail.com',  from:"#{@message.email}", subject: "Website Enquiry: #{@message.subject}")
    end
  end
end
