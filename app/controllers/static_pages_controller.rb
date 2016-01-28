class StaticPagesController < ApplicationController


  def home
  end
  
  def help
  end
  
  def day_picker
  end
  
  def booking_confirm
    @booking = params[:booking]
  end
  
  def booking_enquiry
  end
  
  def hfsk_home
  end
  
  def hfsk_about
  end
  
  def hfsk_menu
  end
  
  def hfsk_location
  end
  
  def hfsk_get_in_touch
      @message = Message.new
      @customer = Customer.new
  end
  
  def download_pdf
    send_file(
      "#{Rails.root}/public/Sample_Menu_V1.pdf",
      filename: "Sample_Menu_V1.pdf",
      type: "application/pdf"
    )
  end

end
