class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  
  def booking_confirmation
    # run validation
    validate = Booking.validate_params(params[:booking])
      
      # if clean create booking object
      if validate.blank?
        # get formatted @booking 
        @to_booking = Booking.format_booking(params[:booking])
        
         # try to book
         @booking = Booking.can_book(@to_booking)
         if @booking.blank?
           redirect_to static_pages_booking_enquiry_path(@booking), notice: 'Sorry, we cannot accomodate your party at this time and date. Would you like to adjust your request and try again?'   
         else
           redirect_to edit_booking_path(@booking)
         end 
        
      else
        # send user back to booking page
        redirect_to static_pages_booking_enquiry_path(@booking), notice: validate
      end

      

  end
  
  def booking_cancellation
     Rails.logger.debug("cancellation: #{params[:booking]}")
     booking_id = params[:booking]
     Booking.update(booking_id, :status => 'Cancelled', :cancelled_at => Time.now)
      redirect_to edit_booking_path(booking_id)
  end
  
  # GET /bookings
  # GET /bookings.json
  def index
  @bookings = []
  #take params from search on Index view, or if no search, assume todays date
  #send to model to apply SEARCH function, which retrieves matching records and requests only CONFIRMED records
   if params[:search]
     @bookings = Booking.search(params[:search])
     if @bookings.any?
      @bookings = @bookings.sort_by { |hsh| hsh[:booking_date_time] }
      
     else
       @bookings = 0
     end
     params[:search]= []
   else
     @bookings = Booking.where(:booking_date => Date.today, :status => "Confirmed")
       if @bookings.any?
          @bookings = @bookings.sort_by { |hsh| hsh[:booking_date_time] }
       else
         @bookings = 0
       end
   end
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

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)

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

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:table_id, :customer_id, :restaurant_id, :booking_date, :booking_time, :booking_date_time, :number_of_diners, :accessible, :child_friendly, :name, :phone, :email, :status, :cancelled_at, customer_attributes:[:_destroy, :id, :name, :phone, :email, :desc, :accessible, :child_friendly])
    end
end
