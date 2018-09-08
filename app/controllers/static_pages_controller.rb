class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:function_room_enquiry]
 
  def home
  end
  
  def help
  end
  
  def hfsk_pay_deposit
  #  Rails.logger.debug("xxxxx_static_pages_PAY_DEPOSIT : #{params.inspect}")
    @error = params["error"]   
       @bookings =[]   
      #take params from search on view, note need all params to make use of search code on booking.rb even though some are hidden, or if no search, 
      #send to model to apply SEARCH function, which retrieves matching records and requests only CONFIRMED records
       if params[:booking]
       
         @bookings = Booking.all_search(params[:booking])
               if @bookings.any?
                 params[:booking]= []
                 @bookings = @bookings.sort_by { |hsh| hsh[:booking_date_time] }
               else
                 params[:booking]= []
                 @bookings = 0
               end
       else
          @bookings = []
      
         params[:booking]= []
       end
  end
  
  def hfsk_confirm_deposit
     # Rails.logger.debug("xxxxx_static_pages_CONFIRM_DEPOSIT : #{params.inspect}")
         @booking = Booking.find(params["id"])
  end
  
  def day_picker
  end
  
  def booking_confirm
    @booking = params[:booking]
  end
  
  def booking_enquiry
  end
  
  def booking_advanced
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", @date.beginning_of_month.beginning_of_day, @date.end_of_month.end_of_day).where(:status => "Confirmed")
    @bookings_by_date = @bookings.group_by {|i| i.booking_date_time.to_date}     
  end
  
  #testing for new availability
  def new_booking_enquiry
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", @date.beginning_of_month.beginning_of_day, @date.end_of_month.end_of_day).where(:status => "Confirmed")
    @bookings_by_date = @bookings.group_by {|i| i.booking_date_time.to_date}     
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
  
  def hfsk_get_in_touch
    unless @message
      @message = Message.new
    end
  end
  
  def download_lunch_pdf
    send_file(
      "#{Rails.root}/public/HF_LUNCH_SAMPLE_0118.pdf",
      filename: "HF_LUNCH_SAMPLE_0118.pdf",
      type: "application/pdf"
    )
  end
  
  def download_evening_pdf
    send_file(
      "#{Rails.root}/public/HF_SAMPLE_MENU_EVENING_0118.pdf",
      filename: "HF_SAMPLE_MENU_EVENING_0118.pdf",
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
