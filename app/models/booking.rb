class Booking < ActiveRecord::Base
  belongs_to :table
  
  # default_scope { order('booking_date_time DESC') }
   
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
       return Error.get_msg("999999101") 
      end 
 
    #2a) check to ensure booking is not in the past
      if (params[:booking_date]).to_date < Date.today
        return Error.get_msg("999999102") 
      end
      
      #2b) check to ensure booking is not before opening date
      opening_date = Date.new(2016,3,9)
        if (params[:booking_date]).to_date < opening_date
          return Error.get_msg("999999115")
        end
    
    #3) check to ensure booking is not for TODAY 
      if (params[:booking_date]).to_date == Date.today
        return Error.get_msg("999999112") 
      end
    
    #4) check to ensure booking is not Monday or Tuesday
      if ([1,2].include? (params[:booking_date]).to_date.wday)
        return Error.get_msg("999999103")    
      end
      
    #5) check to ensure booking is within opening hours, w,t
       if ([3,4].include? (params[:booking_date]).to_date.wday) &&
         ([12,13,14,15,16].include? (params[:booking_time_hour]).to_i)
        return Error.get_msg("999999104")      
      end
  
    #6) check to ensure booking is within opening hours sunday
       if ([0].include? (params[:booking_date]).to_date.wday) &&
         ([16,17,18,19,20,21,22,23].include? (params[:booking_time_hour]).to_i)
        return Error.get_msg("999999105")      
     end  
     
     #7a) check to ensure booking is not between 3pm and 5pm on fri 
        if ([5].include? (params[:booking_date]).to_date.wday) &&
          ([15,16].include? (params[:booking_time_hour]).to_i)
         return Error.get_msg("999999116")      
      end 
      
      
      #7b) check to ensure booking is not between 3pm and 5pm on sat
         if ([6].include? (params[:booking_date]).to_date.wday) &&
           ([15,16].include? (params[:booking_time_hour]).to_i)
          return Error.get_msg("999999116")      
       end 
       
       #7c) check to ensure booking is not at 2.30pm on sat
          if ([6].include? (params[:booking_date]).to_date.wday) &&
            ([14].include? (params[:booking_time_hour]).to_i) &&
            ([30].include? (params[:booking_time_min]).to_i)
           return Error.get_msg("999999116")      
        end 
        
        #7d) check to ensure booking is not at 2.30pm on fri
           if ([5].include? (params[:booking_date]).to_date.wday) &&
             ([14].include? (params[:booking_time_hour]).to_i) &&
             ([30].include? (params[:booking_time_min]).to_i)
            return Error.get_msg("999999116")      
         end 
      
      #8) check to ensure booking is not 9.30pm on any day (NOTE as of 14.apr.2016 this is irrelevant as 9.00 has been removed from clock - leaving here as a safety valve)
         if ((params[:booking_time_hour])== "21" && (params[:booking_time_min])=="30")
          return Error.get_msg("999999117")      
       end 
        
       
#       #9) check to ensure booking is not 5.00pm on wed, thurs
#       if ([3,4].include? (params[:booking_date]).to_date.wday) &&
#         ([17].include? (params[:booking_time_hour]).to_i) &&
#         ([0].include? (params[:booking_time_min]).to_i)
#        return Error.get_msg("999999118")      
#     end    
     
#       #10) check to ensure booking is not 12.00pm on fri, sat
#       if ([5,6,0].include? (params[:booking_date]).to_date.wday) &&
#         ([12].include? (params[:booking_time_hour]).to_i) &&
#         ([0].include? (params[:booking_time_min]).to_i)
#        return Error.get_msg("999999118")      
#     end    
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
        return 999999107
      end
    when 8, 7 
        if (@large_tables_count < @large_table_max)
          @booking = Booking.new(@booking)
          @booking.save
          return @booking
        else
          #Error for too many large groups, return Integer to prevent automated re-book
        return 999999108
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
  
def self.validate_cancellation(params)
    #check to user entered phone or email   
    if (params[:validation_text]).blank?
        return Error.get_msg("999999114") 
     else 
       @booking = Booking.find(params[:booking])
           if ((params[:validation_text].delete(' '))== @booking.phone.delete(' ')) || ((params[:validation_text].downcase)== @booking.email.downcase)
             return
           else
              return Error.get_msg("999999113") 
           end
        end 
end
  
def self.all_search(search)
 name = search[:name]
 email = search[:email]
 phone = search[:phone]
 booking_date_time = search[:booking_date_time].to_date
 
 if !name.blank?
      Rails.logger.debug("in name: #{name}")
      where("name LIKE ?", "%#{name}%") 
   elsif !email.blank?
        Rails.logger.debug("in email: #{email}")
        where("email LIKE ?", "%#{email}%")  
    elsif !phone.blank?
        Rails.logger.debug("in phone: #{phone}")
        where("phone LIKE ?", "%#{phone}%") 
    elsif !booking_date_time.blank?
        Rails.logger.debug("in booking_date_time: #{booking_date_time}")
        where("booking_date_time > ? AND booking_date_time < ?", "%#{booking_date_time.beginning_of_day}%", "%#{booking_date_time.end_of_day}%") 
      else
        @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", Date.today.beginning_of_month.beginning_of_day, Date.today.end_of_month.end_of_day)
      
      end
 end
  
  def self.search(search)
    # get Confirmed bookings only
    date = search.to_date
    @bookings = where("booking_date_time BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).where(:status => "Confirmed")
  end
  
end
