class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  
  def booking_confirmation
    @booking  = params[:booking]
    
    #customer selected parameters
    number_of_diners = params[:booking][:number_of_diners]
    booking_time_hour = params[:booking][:booking_time_hour]
    booking_time_min = params[:booking][:booking_time_min]
    booking_date_day = params[:booking]["booking_date(3i)"]
    booking_date_month = params[:booking]["booking_date(2i)"]
    booking_date_year = params[:booking]["booking_date(1i)"]
    booking_time = (booking_time_hour+":"+booking_time_min+":00").to_s
    booking_time_early = (booking_time.to_time - (1.hour + 59.minutes)).to_s
    booking_time_late = (booking_time.to_time + (1.hour + 59.minutes)).to_s
    booking_date = (booking_date_year + "-" + booking_date_month + "-" + booking_date_day).to_s
    
    #work out if there is a table free
    #first get all tables that match number of diners
    tables = Table.where("min_seats = ? OR max_seats >= ?", number_of_diners,number_of_diners).pluck(:id)
    Rails.logger.debug("TABLES MATCHING SEATS SEARCH: #{tables}")
    
     @booking=[]
    #second get all existing bookings for booking_date and within a 2 hours window from start of requested booking
    tables.each do |table|
        
       if ((Booking.where("booking_date = ? AND table_id = ? AND booking_time BETWEEN ? AND ?", booking_date, table, booking_time_early, booking_time_late).count) == 0)
            
        Rails.logger.debug("FOUND ZERO CREATE BOOKING")
        
        @booking = Booking.create(number_of_diners: number_of_diners, 
         booking_time: booking_time, booking_date: booking_date, table_id: table )
        @booking.save
            redirect_to edit_booking_path(@booking) and return
        end
      end
              
        if @booking.empty?
          redirect_to static_pages_booking_enquiry_path(@booking), notice: 'Sorry, we have no tables at this time and date.Would you like to adjust your request and try again?'       
        end
  end
  
  # GET /bookings
  # GET /bookings.json
  def index
  #  @bookings = Booking.all
  #  @bookings = Booking.search(params[:search])
  @bookings = []
   if params[:search]
     @bookings = Booking.search(params[:search])
     # @bookings= @bookings.sort_by {|k, v| v[:table_id] }
     @bookings_by_table = @bookings.group_by { |t| t.table_id }
      Rails.logger.debug("bookings_by_table: #{@bookings_by_table.inspect}")
     params[:search]= []
   else
     @bookings = Booking.where(:booking_date => Date.today)
     @bookings_by_table = @bookings.group_by { |t| t.table_id }
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
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
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
      params.require(:booking).permit(:table_id, :customer_id, :booking_date, :booking_time, :number_of_diners, :accessible, :child_friendly, :name, :phone, :email, customer_attributes:[:_destroy, :id, :name, :phone, :email, :desc, :accessible, :child_friendly])
    end
end
