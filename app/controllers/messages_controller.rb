class MessagesController < ApplicationController
  def new
     @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
        if @message.valid? #&& verify_recaptcha(model: @message) 
            MessageMailer.send_message(@message).deliver_now
            redirect_to :back, notice: "Message sent! Thank you for contacting Hang Fire."
      else
        redirect_to hfsk_get_in_touch_path, :flash => { :error => @message.errors.full_messages.join(', ') }
      
        end
  end
  
  def message_params
    params.require(:message).permit(:name, :phone, :email, :subject, :message)
  end
end
