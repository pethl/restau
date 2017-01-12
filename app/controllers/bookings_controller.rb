class BookingsController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :create, :mgmt_edit, :download_bookings_pdf, :all_bookings, :basic_report, :calendar, :search_bookings, :new_booking_enquiry]
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :mgmt_edit]
  
  def all_bookings
    @bookings = Booking.all
    @bookings = @bookings.sort_by { |hsh| hsh[:booking_date_time] }
  end
  
  def search_bookings
     @bookings = []
    
    #take params from search on Index view, or if no search, 
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
  
  # NEW METHOD OF FINDING AVAILABLE TIMES
  def booking_get_times
    #Check_Entry does basic validations and ensures if large booking that not too many existing bookings exist
    check_entry = Booking.check_entry_params(params[:booking])
    Rails.logger.debug("xxxxx_what is returned check_entry : #{check_entry.inspect}")
    
    if check_entry.blank? || check_entry == true
      hashhere = Booking.get_available_space((params[:booking][:booking_date].to_datetime), (params[:booking][:number_of_diners].to_i))
       
      if hashhere.blank?
        redirect_to static_pages_new_booking_enquiry_path, :flash => { :warning => (Error.get_msg("999999108"))  }
      else
      session[:available_times] = hashhere
      session[:restaurant_id] = Restaurant.all.first.id
      session[:booking_date] = (params[:booking][:booking_date].to_datetime)
      session[:number_of_diners] = (params[:booking][:number_of_diners].to_i)
      redirect_to static_pages_booking_advanced_path #, :flash => { :success => "Please select from available times." }
    end
    else
      redirect_to static_pages_new_booking_enquiry_path, :flash => { :warning => check_entry }
    end
  end
  
  def booking_advanced
    @available_times = session[:available_times]
    session[:available_times] = nil
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
           redirect_to static_pages_new_booking_enquiry_path, :flash => { :warning => Error.get_msg(@booking) }
      
        elsif @booking.is_a? String 
           # generic error message returned for fully booked 
           redirect_to static_pages_new_booking_enquiry_path, :flash => { :warning => Error.get_msg(999999118) }
        
        elsif @booking.is_a? Object
           #original booking successful, proceed to confirmation
           redirect_to edit_booking_path(@booking)  
     
         else  
           #Non-specific, system error.
           redirect_to static_pages_new_booking_enquiry_path, :flash => { :warning => Error.get_msg(999999109) }
         end 
        
      else # if validation comes back with error
        # send user back to booking page and display specific validation error msg
        redirect_to static_pages_new_booking_enquiry_path, :flash => { :warning => validate }
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
        # BookingMailer.booking_confirmation_mgmt(@booking).deliver_now
      end
        #Customer.write_contact(@booking)
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
      format.html { redirect_to static_pages_new_booking_enquiry_path }
      format.json { head :no_content }
    end
  end
  
  def basic_report
    @bookings = Booking.where(status: 'Confirmed').last(15)
    @bookings = @bookings.reverse
  end
  
  def calendar
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", @date.beginning_of_month.beginning_of_day, @date.end_of_month.end_of_day).where(:status => "Confirmed")
    @bookings_by_date = @bookings.group_by {|i| i.booking_date_time.to_date}    
  end
  
  def availability
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", @date.beginning_of_month.beginning_of_day, @date.end_of_month.end_of_day).where(:status => "Confirmed")
    @bookings_by_date = @bookings.group_by {|i| i.booking_date_time.to_date}     
  end
  
  def availability_detail
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", @date.beginning_of_month.beginning_of_day, @date.end_of_month.end_of_day).where(:status => "Confirmed")
    @bookings_by_date = @bookings.group_by {|i| i.booking_date_time.to_date}  
  end
  
  def download_bookings_pdf
    @date = params[:value].to_date
         @bookings_confirmed_unsorted = Booking.where("booking_date_time BETWEEN ? AND ?", @date.beginning_of_day, @date.end_of_day).where(:status => "Confirmed")
          @bookings_confirmed = @bookings_confirmed_unsorted.sort_by { |hsh| hsh[:booking_date_time] }
         @bookings_cancelled_unsorted = Booking.where("booking_date_time BETWEEN ? AND ?", @date.beginning_of_day, @date.end_of_day).where(:status => "Cancelled")
          @bookings_cancelled = @bookings_cancelled_unsorted.sort_by { |hsh| hsh[:booking_date_time] }
         respond_to do |format|
           format.pdf do
             pdf = Prawn::Document.new
             pdf.text ":: HANG FIRE SOUTHERN KITCHEN :: The Pump House, Hood Road, Barry, CF62 5QN"+"\n\n", size: 10
             pdf.text "Confirmed bookings for: " + @bookings_confirmed.first.booking_date_time.strftime('%d %b, %Y'), size: 20, style: :bold
             pdf.text "\n", size: 10
             
             table_data = Array.new
             table_data << ["Time", "Name", "Diners", "Table Number", "Notes"]
             @bookings_confirmed.each do |booking|
                 table_data << [booking.booking_date_time.strftime('%H:%M'), booking.name, booking.number_of_diners, " ", " "]
             end
             pdf.table(table_data) do 
               self.width = 500
               self.cell_style = { :inline_format => true, size: 10 } 
               self.row_colors = ["DDDDDD", "FFFFFF"]
               self.header = true
               
               row(0).font_style = :bold
               
               columns(0).width = 50
               columns(0).align = :center
               columns(1).font_style = :bold
               columns(1).width = 160
               columns(2).width = 40 
               columns(2).align = :center
               columns(3).width = 50
               columns(3).align = :center
               
             end
             
             pdf.text "\n\n", size: 10
             pdf.text "Cancelled bookings for: "+ @bookings_confirmed.first.booking_date_time.strftime('%d %b, %Y'), size: 20, style: :bold 
             
             table_data = Array.new
             table_data << ["When Cancelled?","Time", "Name"]
             @bookings_cancelled.each do |booking|
                 table_data << [booking.cancelled_at.strftime('%H:%M, %d %b'), booking.booking_date_time.strftime('%H:%M'), booking.name]
             end
             pdf.table(table_data) do 
               self.width = 260 
               self.cell_style = { :inline_format => true, size: 10 } 
               self.row_colors = ["DDDDDD", "FFFFFF"]
               self.header = true
               
               row(0).font_style = :bold
               columns(0).width = 100
               columns(1).width = 40
               columns(2).font_style = :bold
               columns(2).width = 120 
               
              end
            
             send_data pdf.render, filename: 'bookings.pdf', type: 'application/pdf', :disposition => 'inline'
           end
         end
       end
       
       def download_bookings_evening_pdf #this is exactly the same as above except time filter is evening only for bookings and cancellations
         @date = params[:value].to_date
              @bookings_confirmed_unsorted = Booking.where("booking_date_time BETWEEN ? AND ?", @date.beginning_of_day.change({ hour: 16, min: 00 }), @date.end_of_day).where(:status => "Confirmed")
               @bookings_confirmed = @bookings_confirmed_unsorted.sort_by { |hsh| hsh[:booking_date_time] }
              @bookings_cancelled_unsorted = Booking.where("booking_date_time BETWEEN ? AND ?", @date.beginning_of_day.change({ hour: 16, min: 00 }), @date.end_of_day).where(:status => "Cancelled")
               @bookings_cancelled = @bookings_cancelled_unsorted.sort_by { |hsh| hsh[:booking_date_time] }
              respond_to do |format|
                format.pdf do
                  pdf = Prawn::Document.new
                  pdf.text ":: HANG FIRE SOUTHERN KITCHEN :: The Pump House, Hood Road, Barry, CF62 5QN"+"\n\n", size: 10
                  pdf.text "Confirmed bookings for: " + @bookings_confirmed.first.booking_date_time.strftime('%d %b, %Y'), size: 20, style: :bold
                  pdf.text "\n", size: 10
             
                  table_data = Array.new
                  table_data << ["Time", "Name", "Diners", "Table Number", "Notes"]
                  @bookings_confirmed.each do |booking|
                      table_data << [booking.booking_date_time.strftime('%H:%M'), booking.name, booking.number_of_diners, " ", " "]
                  end
                  pdf.table(table_data) do 
                    self.width = 500
                    self.cell_style = { :inline_format => true, size: 10 } 
                    self.row_colors = ["DDDDDD", "FFFFFF"]
                    self.header = true
               
                    row(0).font_style = :bold
               
                    columns(0).width = 50
                    columns(0).align = :center
                    columns(1).font_style = :bold
                    columns(1).width = 160
                    columns(2).width = 40 
                    columns(2).align = :center
                    columns(3).width = 50
                    columns(3).align = :center
               
                  end
             
                  pdf.text "\n\n", size: 10
                  pdf.text "Cancelled bookings for: "+ @bookings_confirmed.first.booking_date_time.strftime('%d %b, %Y'), size: 20, style: :bold 
             
                  table_data = Array.new
                  table_data << ["When Cancelled?","Time", "Name"]
                  @bookings_cancelled.each do |booking|
                      table_data << [booking.cancelled_at.strftime('%H:%M, %d %b'), booking.booking_date_time.strftime('%H:%M'), booking.name]
                  end
                  pdf.table(table_data) do 
                    self.width = 260 
                    self.cell_style = { :inline_format => true, size: 10 } 
                    self.row_colors = ["DDDDDD", "FFFFFF"]
                    self.header = true
               
                    row(0).font_style = :bold
                    columns(0).width = 100
                    columns(1).width = 40
                    columns(2).font_style = :bold
                    columns(2).width = 120 
               
                   end
            
                  send_data pdf.render, filename: 'bookings.pdf', type: 'application/pdf', :disposition => 'inline'
                end
              end
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
