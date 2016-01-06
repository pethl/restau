class StaticPagesController < ApplicationController


  def home
  end
  
  def day_picker
  end
  
  def booking_confirm
    @booking = params[:booking]
  end
 

end
