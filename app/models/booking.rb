class Booking < ActiveRecord::Base
  belongs_to :table
  
   default_scope { order('booking_date_time DESC') }
  
  validates :restaurant_id, presence: true 
  validates :booking_date_time, presence: true 
  validates :number_of_diners, presence: true  
  validates :name, :on => :update, presence: true
  validates :phone, :on => :update, presence: true   
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :on => :update, format:  { with: VALID_EMAIL_REGEX }, :exclusion =>  { :in => %w(your@email.com), :message => " : Please enter a contact email." }
  
  
  # VALIDATION ROUTINES FOR BOOKING FORM
  def self.validate_params(params)
    
    #1) check to ensure all form fields are filled   
      if (params[:number_of_diners])== "0" || (params[:booking_time_hour])== "hour" || (params[:booking_time_min])=="min" || (params[:booking_date].blank?)
       return Error.get_msg("101") 
      end 
 
    #2) check to ensure booking is not in the past
      if (params[:booking_date]).to_date < Date.today
        return Error.get_msg("102") 
      end
    
    #3) check to ensure booking for TODAY is completed before 17:15
      if (params[:booking_date]).to_date == Date.today && Time.now > "17:15:00"
        return Error.get_msg("112") 
      end
    
    #4) check to ensure booking is not Monday or Tuesday
      if ([1,2].include? (params[:booking_date]).to_date.wday)
        return Error.get_msg("103")    
      end
      
    #5) check to ensure booking is within opening hours, w,t
       if ([3,4].include? (params[:booking_date]).to_date.wday) &&
         ([12,13,14,15,16].include? (params[:booking_time_hour]).to_i)
        return Error.get_msg("104")      
      end
  
    #6) check to ensure booking is within opening hours sunday
       if ([0].include? (params[:booking_date]).to_date.wday) &&
         ([17,18,19,20,21,22,23].include? (params[:booking_time_hour]).to_i)
        return Error.get_msg("105")      
     end    
   end
  
  
  # CREATE A BOOKING OBJECT FROM FORM RAW PARAMS  
  def self.format_booking(params)
    @booking = Hash.new
    @booking[:restaurant_id] = Restaurant.where(:name => (params[:restaurant])).first.id
    @booking[:number_of_diners] = params[:number_of_diners].to_i
    @booking[:status] = 'Held'
    @booking[:source] = 'Online'
    temp_booking_date = params[:booking_date].to_date
    temp_hour = params[:booking_time_hour].to_i
    temp_min = params[:booking_time_min].to_i
    @booking[:booking_date_time] = DateTime.new(temp_booking_date.year, temp_booking_date.month, temp_booking_date.day, temp_hour, temp_min)
    return @booking
  end
  
  # RUN BOOKING RULES TRY TO CREATE BOOKING  
  def self.can_book(params)
    @booking = params
   
    # GET KEY VALUES FOR CALCULATIONS
    
    # GET ALL EXISTING BOOKINGS FOR THE DAY
    booking_time = @booking[:booking_date_time]
    @existing_bookings = Booking.where("booking_date_time BETWEEN ? AND ?", booking_time.beginning_of_day, booking_time.end_of_day).where(:status => "Confirmed")

    # DINERS IN NEW BOOKING
    @diners = (@booking[:number_of_diners])
        
    # HASH OF EXISTING DINERS NUMBER (USED ONLY FOR LARGE/BIG BOOKINGS)
    @existing_diners_number = @existing_bookings.pluck(:number_of_diners)
    
    # EXISTING TABLES OF 9 OR 10) IN THE DAY COUNT
    @big_tables_count = (@existing_diners_number.count(9))+ (@existing_diners_number.count(10))

    # EXISTING TABLES OF 7 OR 8) IN THE DAY COUNT
    @large_tables_count = (@existing_diners_number.count(8))+ (@existing_diners_number.count(7))
  
    # GET BIG AND LARGE TABLE MAX FROM SYSTEM PARAMETERS
    @big_table_max = Rdetail.get_value(@booking[:restaurant_id], "big_table_count") 
    @large_table_max = Rdetail.get_value(@booking[:restaurant_id], "large_table_count") 
    
    # GET CURRENT DINERS WINDOW START AND END FROM SYSTEM PARAMETERS
    @current_diners_window_start = Rdetail.get_value(@booking[:restaurant_id], "current_diners_window_start") 
    @current_diners_window_end = Rdetail.get_value(@booking[:restaurant_id], "current_diners_window_end") 
    
    # GET MAX CONCURRENT DINERS FROM SYSTEM PARAMETERS
    @max_current_diners = Rdetail.get_value(@booking[:restaurant_id], "max_current_diners") 

    # GET MAX CONCURRENT DINERS FROM SYSTEM PARAMETERS
    @max_diners_at_same_start_time = Rdetail.get_value(@booking[:restaurant_id], "max_diners_at_current_time") 
    
    # GET CURRENT DINERS WINDOW  - EXISTING BOOKINGS AROUND REQUESTED TIME
    # GO THROUGH DAYS' BOOKINGS AND COUNT BOOKINGS THAT ARE WITHIN WINDOW PARAMETERS
     @bookings_at_current_time = Array.new
     start = @booking[:booking_date_time]-((@current_diners_window_start).minutes)   
     finish =  @booking[:booking_date_time]+((@current_diners_window_end).minutes)   
   
     @existing_bookings.each do |existing_booking| 
    
         if ((existing_booking.booking_date_time >= start) && (existing_booking.booking_date_time <= finish))
           @bookings_at_current_time << existing_booking
         else          
         end
      end
      Rails.logger.debug("BOOKING_LOGING_bookings_at_current_time : #{@bookings_at_current_time.count}")  
      
      # TOTAL DINERS COUNT FOR CURRENT BOOKING WINDOW
      @number_of_current_diners= 0
      @number_of_current_diners = @bookings_at_current_time.to_a.sum do |booking_at_current_time|
              booking_at_current_time.number_of_diners
            end
      Rails.logger.debug("BOOKING_LOGING_number_of_current_diners : #{@number_of_current_diners}")  
      
      # TOTAL DINERS COUNT FOR CURRENT TIME
      @diners_at_same_start_time = 0
    #  @bookings_at_same_start_time = Booking.where(:booking_date_time => @booking[:booking_date_time])
      @bookings_at_same_start_time = Booking.where("booking_date_time = ? AND status = ?", @booking[:booking_date_time], "Confirmed")

      @diners_at_same_start_time = @bookings_at_same_start_time.to_a.sum do |booking_at_same_start_time|
              booking_at_same_start_time.number_of_diners
            end
      Rails.logger.debug("BOOKING_LOGING_diners_at_same_start_time : #{@diners_at_same_start_time}")
      
 
       
  if (@number_of_current_diners < (@max_current_diners - @diners)) && ((@diners_at_same_start_time+@diners) < (@max_diners_at_same_start_time+1))
   
    case @diners
    when 9,10
      if (@big_tables_count < @big_table_max)
          @booking = Booking.new(@booking)
          @booking.save
          return @booking
        else
        #Error for too many big groups, return Integer to prevent automated re-book
        return 107
      end
    when 8, 7 
        if (@large_tables_count < @large_table_max)
          @booking = Booking.new(@booking)
          @booking.save
          return @booking
        else
          #Error for too many large groups, return Integer to prevent automated re-book
        return 108
      end
    when 1,2,3,4,5,6
       @booking = Booking.new(@booking)
       @booking.save
       return @booking
     else 
        #Error for ++current diners or ++diners at same time, return string for automated re-book
        msg = "Try again"
       return msg
    end
  end #case statement end

 else 
   #Error for ++current diners or ++diners at same time, return string for automated re-book
   msg = "Try again"
  return msg
end #starer if end 
  
  
  def self.search(search)
    # get Confirmed bookings only
    date = search.to_date
    @bookings = where("booking_date_time BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).where(:status => "Confirmed")
  end
  
end
