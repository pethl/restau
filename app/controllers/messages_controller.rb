class MessagesController < ApplicationController
  def new
     @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
        if @message.valid?
          MessageMailer.send_message(@message).deliver_now
          redirect_to static_pages_hfsk_get_in_touch_path, notice: "Message sent! Thank you for contacting Hang Fire."
        else
          @customer = Customer.new
          render 'static_pages/hfsk_get_in_touch'
        end
  end
  
  def message_params
    params.require(:message).permit(:name, :phone, :email, :subject, :message)
  end
end
