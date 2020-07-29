class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:function_room_enquiry, :hfsk_pay_deposit, :hfsk_find_my_booking, :new_booking_enquiry]
 
  def home
  end
  
  def help
  end
  
  def hfsk_deposit_terms
  end
  
  def hfsk_pay_deposit
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
         @booking = Booking.find(params["id"])
  end
  
  def hfsk_find_my_booking
    @error = params["error"]   
       @bookings =[]   
      #take params from search on view, note need all params to make use of search code on booking.rb even though some are hidden, or if no search, 
      #send to Booking.rb model to apply SEARCH function, which retrieves all matching records, any status, past and present
  
   Rails.logger.debug("xxxxx_PARAMS : #{params.inspect}")
    Rails.logger.debug("xxxxx_PARAMS : #{params[:booking].inspect}")
 # Rails.logger.debug("xxxxx_PARAMS : #{params[:booking][:phone].inspect}")

  if params[:booking].present? 
 
  unless params[:booking][:phone].length == 0 || params[:booking][:phone].length >9
     redirect_to hfsk_find_my_booking_path(@bookings), :flash => { :warning => "Please enter a phone number of at least 10 digits"}
  end
  
       
       #if params[:name].present? || params[:email].present?
         
         @bookings = Booking.all_search(params[:booking])
               if @bookings.any?
                 params[:booking]= []
                 @bookings_filtered =[]   
                # code to remove any past bookings
                 @bookings.each do |booking|
                   if (booking.booking_date_time > Date.today.end_of_day)
                     @bookings_filtered << booking
                   end
                   @bookings = @bookings_filtered
                 end
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
  
  def hfsk_gift_vouchers
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
  
  def download_menu_pdf
    send_file(
      "#{Rails.root}/public/HF_MENU_SAMPLE_1119.pdf",
      filename: "HF_MENU_SAMPLE_1119.pdf",
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
  
 def send_customer_booking_mail(booking)
     Rails.logger.debug("171_booking : #{booking.inspect}")
    @booking = booking
     Rails.logger.debug("171_booking : #{@booking.inspect}")
      Booking_Mailer.send_customer_booking_mail(@booking).deliver
    redirect_to hfsk_find_my_booking_path, :flash => { :success => "Your booking details have been sent to the email address on the booking."}
  end

end
