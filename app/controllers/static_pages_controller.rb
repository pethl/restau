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
 

end
