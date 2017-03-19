class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:function_room_enquiry]
 
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
  
  def function_room_enquiry
      if @function 
      else @function = Function.new
      end
  end
  
  def hfsk_home
  end
  
  def hfsk_about
  end
  
  def hfsk_menu
  end
  
  def hfsk_location
  end
  
  def hfsk_careers
  end
  
  def hfsk_get_in_touch
      @message = Message.new
      @customer = Customer.new
  end
  
  def download_lunch_pdf
    send_file(
      "#{Rails.root}/public/HF_LUNCH_SAMPLE_0317.pdf",
      filename: "HF_LUNCH_SAMPLE_0317.pdf",
      type: "application/pdf"
    )
  end
  
  def download_evening_pdf
    send_file(
      "#{Rails.root}/public/HF_SAMPLE_MENU_EVENING_0317.pdf",
      filename: "HF_SAMPLE_MENU_EVENING_0317.pdf",
      type: "application/pdf"
    )
  end
  
  def download_festive_pdf
    send_file(
      "#{Rails.root}/public/HF_FESTIVE_MENU.pdf",
      filename: "HF_FESTIVE_MENU.pdf",
      type: "application/pdf"
    )
  end
  
  def download_function_pdf
    send_file(
      "#{Rails.root}/public/HF_ENGINE_ROOM_MENU_2016.pdf",
      filename: "HF_ENGINE_ROOM_MENU_2016.pdf",
      type: "application/pdf"
    )
  end
  
  def download_engine_tandc_pdf
    send_file(
      "#{Rails.root}/public/HF_ENGINE_ROOM_HIRE_T&Cs.pdf",
      filename: "HF_ENGINE_ROOM_HIRE_T&Cs.pdf",
      type: "application/pdf"
    )
  end

end
