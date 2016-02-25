class BookingsController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :create, :basic_report, :calendar, :mgmt_edit]
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :mgmt_edit]
  
  def all_bookings
    @bookings = Booking.all
  end
  
  def search_bookings
     @bookings = []
    
    #take params from search on Index view, or if no search, 
    #send to model to apply SEARCH function, which retrieves matching records and requests only CONFIRMED records
     if params[:booking]
       @bookings = Booking.all_search(params[:booking])
             if @bookings.any?
               params[:booking]= []
               @bookings
             else
               params[:booking]= []
               @bookings = 0
             end
     else
        @bookings = []
      
       params[:booking]= []
     end
  end
  
  def booking_confirmation
    # run validation # if clean create booking object
    validate = Booking.validate_params(params[:booking])
    if validate.blank?
        
      # run formatting 
      @to_booking = Booking.format_booking(params[:booking])
       
      # attempt booking
      @booking = Booking.can_book(@to_booking)
      
      if @booking.is_a? Integer
      # specific error msge returned, cannot book
      redirect_to static_pages_booking_enquiry_path, :flash => { :warning => Error.get_msg(@booking) }
      
      elsif @booking.is_a? String  
        # try booking 15 mins earlier unless time is 5pm
             # b_time = @to_booking[:booking_date_time]
              b_time = @to_booking[:booking_date_time].hour.to_s + ":" + @to_booking[:booking_date_time].min.to_s
              b_day = @to_booking[:booking_date_time].wday
              if (([3,4].include? b_day) &&(b_time=="17:0")) || (([5,6,0].include? b_day) && (b_time=="12:0"))
                  # do not change the booking time
              else
               @to_booking[:booking_date_time] = (@to_booking[:booking_date_time]-15.minutes)
              end
          
          # try to re-book with revised time (once)
          @booking = Booking.can_book(@to_booking) 
          Rails.logger.debug("xxxxxxxxxxxxx_Second Call to Booking : #{@booking.inspect}")  
    
             if @booking.is_a? String
               #-------------------------------
               # try booking 30 mins later unless time is 21.15
                     b_time = @to_booking[:booking_date_time].hour.to_s + ":" + @to_booking[:booking_date_time].min.to_s
                      if (b_time=="21:15") # no need for sunday check here as latest they can book is 16.45
                      # do not change the booking time
                      else
                      @to_booking[:booking_date_time] = (@to_booking[:booking_date_time]+30.minutes)
                      end
          
                  # try to re-book with revised time (twice)
                 @booking = Booking.can_book(@to_booking) 
                 Rails.logger.debug("xxxxxxxxxxxxx_Third Call to Booking : #{@booking.inspect}")  
    
                    if @booking.is_a? String
                      msg = "Sorry we do not have a table within 15 mins +/- this time. Please try earlier or later."
                      redirect_to static_pages_booking_enquiry_path, :flash => { :warning => msg }
                   else
                      redirect_to edit_booking_path(@booking), notice: Error.get_msg(111)
                   end 
               #-------------------------------
            else
               redirect_to edit_booking_path(@booking), notice: Error.get_msg(110)
            end 
      
      elsif @booking.is_a? Object
         #original booking successful, proceed to confirmation
         redirect_to edit_booking_path(@booking)  
     
       else  
         #Non-specific, system error.
         redirect_to static_pages_booking_enquiry_path, :flash => { :warning => Error.get_msg(109) }
       end 
        
      else # if validation comes back with error
        # send user back to booking page and display specific validation error msg
        redirect_to static_pages_booking_enquiry_path, :flash => { :warning => validate }
      end
      

  end
  
  def booking_cancellation
    validate = Booking.validate_cancellation(params)
    booking_id = params[:booking]
    @booking = Booking.find(booking_id)
    
    if validate.blank?
     Booking.update(booking_id, :status => 'Cancelled', :cancelled_at => Time.now)
     BookingMailer.booking_cancellation_customer(booking_id).deliver_now
     BookingMailer.booking_cancellation_mgmt(booking_id).deliver_now
      redirect_to edit_booking_path(booking_id)
    else
      redirect_to edit_booking_path(booking_id), :flash => { :warning => validate }
    end
  end
  
  # GET /bookings
  # GET /bookings.json
  def index
  @bookings = []
  #take params from search on Index view, or if no search, assume todays date
  #send to model to apply SEARCH function, which retrieves matching records and requests only CONFIRMED records
   if !params[:search].blank?
     @bookings = Booking.search(params[:search])
       if @bookings.any?
        @bookings = @bookings.sort_by { |hsh| hsh[:booking_date_time] }
      
       else
         @bookings = 0
       end
       params[:search]= []
   else
     @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", Date.today.beginning_of_day, Date.today.end_of_day).where(:status => "Confirmed")
       if @bookings.any?
          @bookings = @bookings.sort_by { |hsh| hsh[:booking_date_time] }
       else
         @bookings = 0
       end
   end
   
 else
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end
  
  # GET /bookings/1/edit
  def mgmt_edit
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)
    if @booking.name.blank? 
      redirect_to new_booking_path(@booking), :flash => { :warning => "NOT BOOKED : Please enter Customer Name" }
    else 
   
    respond_to do |format|
      if @booking.save
        format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        unless @booking.email =="adminhangfirebbq@gmail.com"
        BookingMailer.booking_confirmation_customer(@booking).deliver_now
        BookingMailer.booking_confirmation_mgmt(@booking).deliver_now
      end
        Customer.write_contact(@booking)
        format.html { redirect_to @booking }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { redirect_to edit_booking_path(@booking), :flash => { :error => @booking.errors.full_messages.join(', ') }}
        
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to static_pages_booking_enquiry_path }
      format.json { head :no_content }
    end
  end
  
  def basic_report
  end
  
  def calendar
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", @date.beginning_of_month.beginning_of_day, @date.end_of_month.end_of_day).where(:status => "Confirmed")
    @bookings_by_date = @bookings.group_by {|i| i.booking_date_time.to_date}  
       Rails.logger.debug("in calendar_b_group: #{@bookings_by_date}")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:table_id, :customer_id, :restaurant_id, :source, :booking_date, :booking_time, :booking_date_time, :number_of_diners, :accessible, :child_friendly, :name, :phone, :email, :status, :cancelled_at, customer_attributes:[:_destroy, :id, :name, :phone, :email, :desc, :accessible, :child_friendly])
    end
    
    # Confirms a logged-in user.
        def logged_in_user
          unless logged_in?
           
            flash[:danger] = "Please log in."
            redirect_to login_url
          end
        end
        
        def booking_made_in_this_month(date)
          Booking.where("booking_date_time BETWEEN ? AND ?", date.beginning_of_month.beginning_of_day, date.end_of_month.end_of_day).where(:status => "Confirmed")
        end
end
