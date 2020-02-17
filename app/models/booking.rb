class Booking < ActiveRecord::Base
  belongs_to :table
  
  # default_scope { order('booking_date_time DESC') }
   
  validates :restaurant_id, presence: true 
  validates :booking_date_time, presence: true 
  validates :number_of_diners, presence: true  
  validates :name, :on => :update, presence: true
 # validates :email, :on => :update, presence: true  
  validates :phone, :on => :update, presence: true  
  validates :phone, format: { without: /\s/, message: ":no spaces please."}
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :on => :update, format:  { with: VALID_EMAIL_REGEX }, :exclusion =>  { :in => %w(your@email.com), :message => " : Please enter a contact email." }

  
  def self.check_entry_params(params)
    #001) FIRST LINE VALIDATIONS   
      #B1) check to ensure both form fields are filled   
        if (params[:number_of_diners])== "0" || (params[:booking_date].blank?)
         return Error.get_msg("999999101") 
        end 
      
       #B2) DUP check to ensure booking is not in the past  
      if (params[:booking_date]).to_date < Date.today
        return Error.get_msg("999999102") 
      end
      
      #B3) DUP check to ensure booking is not for TODAY 
      # CHANGE 24/10/2019 TO ALLOW SAME DAY BOOKINGS UNTIL 2PM (but due to server time have to set to 1pm)
        if ([3,4].include? (params[:booking_date]).to_date.wday)
          
            #B3b) New error message - if user is trying to book today but after 2pm
              if (params[:booking_date]).to_date == Date.today && Time.now>"14:00".to_s
                return Error.get_msg("999999125") 
              end  
          
           # if not WED or THURS leave code as is and don't allow same day bookings
          elsif (params[:booking_date]).to_date == Date.today 
              return Error.get_msg("999999112") 
            end
          
      #H1) DUP check to ensure booking is not Monday or Tuesday
        if ([1,2].include? (params[:booking_date]).to_date.wday)
          return Error.get_msg("999999103")    
        end
      
      # REMOVED JAN 2017 - 12) DUP check to ensure booking is not in December
      #  if (([12].include? (params[:booking_date]).to_date.month) && (params[:number_of_diners].to_i >4))
      #   return Error.get_msg("999999107")    
      #  end
      
      #B4) DUP check to ensure booking is not after latest booking *currently 6 months from end of month
      #CHANGE TO ALLOW XMAS BOOKINGS AND 2018 ROLLING 6 MONTHS
        if  (params[:booking_date]).to_date > ((Date.today.end_of_month)+3.months)
       #CHANGE TO LIMIT XMAS BOOKING ON 3 JUNE 2017
       # if  (params[:booking_date]).to_date > Date.new(2017,10,31)
          return Error.get_msg("999999123")    
        end
        
      #B5) Check to ensure booking date is not on list of exemption dates
      # 2 part changes made to handle valentines day exception. If exemption day is part exemption only carry on. Later in the flow handling for part exemptions.
      exempt_days_hash = Exemption.where("exempt_day >= ? AND lunch= ? AND dinner = ?",Date.today,true,true)
      if exempt_days_hash.count > 0
        exempt_days_hash.each do |exemption|
            if params[:booking_date].to_date == exemption.exempt_day.to_date
              return exemption.exempt_message
            end
         end
       else 
      end  
    
      #start of jan 12 work to remove large table duplicates
      check_for_big_tables = Booking.check_for_big_tables_params(params)
      unless check_for_big_tables.blank?
          return Error.get_msg("999999108")  
      end
      
      #B6) check to ensure no tables of 11+ after Jan 3 
        if (params[:number_of_diners].to_i)>= 11 && (params[:booking_date]).to_date > Date.new(2018,01,01)
         return Error.get_msg("999999124") 
        end 
      
  end
  
  
  # VALIDATION ROUTINES FOR BOOKING FORM
  def self.validate_params(params)
    
    #B1) check to ensure all form fields are filled   
      if (params[:number_of_diners])== "0" || (params[:booking_time_hour])== "hour" || (params[:booking_time_min])=="min" || (params[:booking_date].blank?)
       return Error.get_msg("999999101") 
      end 
 
    #B2) check to ensure booking is not in the past
      if (params[:booking_date]).to_date < Date.today
        return Error.get_msg("999999102") 
      end
    
    #B3) DUP check to ensure booking is not for TODAY 
      # CHANGE 24/10/2019 TO ALLOW SAME DAY BOOKINGS UNTIL 2PM (but due to server time have to set to 1pm during clock change)
    if ([3,4].include? (params[:booking_date]).to_date.wday)
      
        #B3b) New error message - if user is trying to book today but after 2pm
        if (params[:booking_date]).to_date == Date.today && Time.now>"14:00".to_s
          return Error.get_msg("999999125") 
        end  
      
       # if not WED or THURS leave code as is and don't allow same day bookings
    elsif (params[:booking_date]).to_date == Date.today 
          return Error.get_msg("999999112") 
    end
    
    #H1) check to ensure booking is not MON or TUES
      if ([1,2].include? (params[:booking_date]).to_date.wday)
        return Error.get_msg("999999103")    
      end
      
    #H2a) check to ensure booking is within opening hours, WED , THURS
       if ([3,4].include? (params[:booking_date]).to_date.wday) &&
         ([12,13,14,15,16].include? (params[:booking_time_hour]).to_i)
        return Error.get_msg("999999104")      
      end
  
    #H2b) check to ensure booking is within opening hours SUN
       if ([0].include? (params[:booking_date]).to_date.wday) &&
         ([16,17,18,19,20,21,22,23].include? (params[:booking_time_hour]).to_i)
        return Error.get_msg("999999105")      
     end  
     
     #6b) check to ensure booking is not at 3.30pm on SUN, last booking 3pm
     # AMENDED 08/JAN/2019 - email from Shauna, allow 3.30 bookings on Sunday
    #    if ([0].include? (params[:booking_date]).to_date.wday) &&
    #      ([15].include? (params[:booking_time_hour]).to_i) &&
    #      ([30].include? (params[:booking_time_min]).to_i)
    #     return Error.get_msg("999999105")      
    #  end 
      
      #S4a) check to ensure booking is not 3pm on SUN if group size is 7 or more
         if ([0].include? (params[:booking_date]).to_date.wday) &&
           ([15].include? (params[:booking_time_hour]).to_i) &&
           ([0].include? (params[:booking_time_min]).to_i)  &&
           ([7,8,9,10,11,12].include? (params[:number_of_diners]).to_i)
          return Error.get_msg("999999122")      
       end 
       
       #S4b) check to ensure booking is not 3.30pm on SUN if group size is 7 or more
          if ([0].include? (params[:booking_date]).to_date.wday) &&
            ([15].include? (params[:booking_time_hour]).to_i) &&
            ([30].include? (params[:booking_time_min]).to_i)  &&
            ([7,8,9,10,11,12].include? (params[:number_of_diners]).to_i)
           return Error.get_msg("999999122")      
        end  
      
      #H4) check to ensure booking is not between 3pm and 5pm on SAT
         if ([6].include? (params[:booking_date]).to_date.wday) &&
           ([15,16].include? (params[:booking_time_hour]).to_i)
          return Error.get_msg("999999116")      
       end 
       
       #REMOVED 1/10/2019, Shauna. Start allowing lunch tables at 2.30 FRI and SAT
       #7b) check to ensure booking is not at 2.30pm on sat
    #      if ([6].include? (params[:booking_date]).to_date.wday) &&
    #        ([14].include? (params[:booking_time_hour]).to_i) &&
    #        ([30].include? (params[:booking_time_min]).to_i)
    #       return Error.get_msg("999999116")      
    #    end 
        
      #H3) check to ensure booking is not between 3pm and 5pm on FRI 
        if ([5].include? (params[:booking_date]).to_date.wday) &&
          ([15,16].include? (params[:booking_time_hour]).to_i)
         return Error.get_msg("999999116")      
      end 
      
      #REMOVED 1/10/2019, Shauna. Start allowing lunch tables at 2.30 FRI and SAT
      #8b) check to ensure booking is not at 2.30pm on FRI
     #    if ([5].include? (params[:booking_date]).to_date.wday) &&
     #      ([14].include? (params[:booking_time_hour]).to_i) &&
     #      ([30].include? (params[:booking_time_min]).to_i)
     #      return Error.get_msg("999999116")      
     #   end 
   
     #S3) check to ensure booking is not 2.00pm on f,s if group size is 7 or more
        if ([5,6].include? (params[:booking_date]).to_date.wday) &&
          ([14].include? (params[:booking_time_hour]).to_i) &&
          ([0].include? (params[:booking_time_min]).to_i)  &&
          ([7,8,9,10,11,12].include? (params[:number_of_diners]).to_i)
         return Error.get_msg("999999121")      
      end 
  
      #H5) check to ensure booking is not 9.30pm on any day (NOTE as of 14.apr.2016 this is irrelevant as 9.00 has been removed from clock - leaving here as a safety valve)
         if ((params[:booking_time_hour])== "21" && (params[:booking_time_min])=="30")
          return Error.get_msg("999999117")      
       end 
        
       #S2) check to ensure booking is not 8.30pm on w,t,f,s if group size is 7 or more
          if ([3,4,5,6].include? (params[:booking_date]).to_date.wday) &&
            ([20].include? (params[:booking_time_hour]).to_i) &&
            ([30].include? (params[:booking_time_min]).to_i)  &&
            ([7,8,9,10,11,12].include? (params[:number_of_diners]).to_i)
           return Error.get_msg("999999119")      
        end 

      #12) check to ensure booking is not in December
      #    if ([12].include? (params[:booking_date]).to_date.month)
      #      return Error.get_msg("999999120")    
      #    end
    
     #B4) DUP check to ensure booking is not after latest booking *curently 6 months from end of month
     #CHANGE TO ALLOW XMAS BOOKINGS AND 2018 ROLLING 6 MONTHS
     if  (params[:booking_date]).to_date > ((Date.today.end_of_month)+3.months)
     #CHANGE TO LIMIT XMAS BOOKING ON 3 JUNE 2017
     #if  (params[:booking_date]).to_date > Date.new(2017,10,31)
        return Error.get_msg("999999123")    
      end
      
      #14) start of jan 12 work to remove large table duplicates
      check_for_big_tables = Booking.check_for_big_tables_params(params)
      unless check_for_big_tables.blank?
          return Error.get_msg("999999108")  
      end
      
      #B6) check to ensure no tables of 11+ after Jan 3 
        if (params[:number_of_diners].to_i)>= 11 && (params[:booking_date]).to_date > Date.new(2018,01,01)
         return Error.get_msg("999999124") 
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
      
    # GET MAX CONCURRENT DINERS FROM SYSTEM PARAMETERS
    @max_diners_at_current_time = Rdetail.get_value(@booking[:restaurant_id], "max_diners_at_current_time") 
   # Rails.logger.debug("232_new_BOOKING_LOGING_MAX_diners_at_same_start_time : #{@max_diners_at_current_time}")


    if ([3,4].include? (@booking[:booking_date_time].to_date.wday)) &&  @booking[:booking_date_time].hour== 17 &&  @booking[:booking_date_time].min== 0
        @max_diners_at_current_time = Rdetail.get_value(1, "wed_thurs_eve_max_diners") 
  #   Rails.logger.debug("237_BOOKING_LOGING_diners_at_same_start_time : #{@max_diners_at_current_time}")
  #   Rails.logger.debug("238_BOOKING_L : #{@booking[:booking_date_time]}")
      elsif ([3,4].include? (@booking[:booking_date_time].to_date.wday)) &&  @booking[:booking_date_time].hour== 17 &&  @booking[:booking_date_time].min== 30
         @max_diners_at_current_time = Rdetail.get_value(1, "wed_thurs_eve_max_diners")-2
      elsif ([5].include? (@booking[:booking_date_time].to_date.wday))&&  ([12,13].include? @booking[:booking_date_time].hour)
         @max_diners_at_current_time = Rdetail.get_value(1, "max_fri_lunch_diners") 
      elsif ([0].include? (@booking[:booking_date_time].to_date.wday))
          @max_diners_at_current_time = Rdetail.get_value(1, "sun_max_diners") 
        # Rails.logger.debug("246_BOOKING_LOGING_diners_at_same_start_time : #{@booking[:booking_date_time]}")   
      else     
        @max_diners_at_current_time = Rdetail.get_value(1, "max_diners_at_current_time") 
       # Rails.logger.debug("249_BOOKING_LOGING_diners_at_same_start_time : #{@max_diners_at_current_time}")
       # Rails.logger.debug("250_BOOKING_L : #{@booking[:booking_date_time]}")   
    end
    
      
      # TOTAL DINERS COUNT FOR CURRENT TIME
      @diners_at_same_start_time = 0
      a = @booking[:booking_date_time]
      @bookings_at_same_start_time = Booking.where("booking_date_time BETWEEN ? AND ?", a,(a+15.minutes)).where(:status => "Confirmed")
      @diners_at_same_start_time = @bookings_at_same_start_time.to_a.sum do |booking_at_same_start_time|
              booking_at_same_start_time.number_of_diners
            end
      
    if ((@diners_at_same_start_time+@diners) < (@max_diners_at_current_time+1))
  
    case @diners
    when 9,10,11,12
          @booking = Booking.new(@booking)
          @booking.save
          return @booking
    when 8, 7 
          @booking = Booking.new(@booking)
          @booking.save
          return @booking
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
 name_search = search[:name].downcase
 email_search = search[:email].downcase
 phone = search[:phone]
 booking_date_time = search[:booking_date_time].to_date
 
 if !name.blank?
      where("lower(name) LIKE ?", "%#{name_search}%") 
   elsif !email.blank?
        where("lower(email) LIKE ?", "%#{email_search}%")  
    elsif !phone.blank?
        where("phone LIKE ?", "%#{phone}%") 
    elsif !booking_date_time.blank?
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
  
  
  # THIS FUNCTION FINDS AVAILABLE SPACES PER DAY FOR THE SPECIFIED NUMBER OF DINERS ELSE RETURNS ERROR
  def self.get_available_space(booking_datetime, number_of_diners)
    @existing_bookings = Booking.where("booking_date_time BETWEEN ? AND ?", booking_datetime.beginning_of_day, booking_datetime.end_of_day).where(:status => "Confirmed")
    @max_diners_at_current_time = Rdetail.get_value(1, "max_diners_at_current_time")    
    @lunch_existing_bookings = Booking.where("booking_date_time BETWEEN ? AND ?", booking_datetime.beginning_of_day, booking_datetime.change({ hour: 16, min: 55 })).where(:status => "Confirmed")
    @eve_existing_bookings = Booking.where("booking_date_time BETWEEN ? AND ?", booking_datetime.change({ hour: 17, min: 00 }), booking_datetime.end_of_day).where(:status => "Confirmed")
    
    # HASH OF EXISTING DINERS NUMBER (USED ONLY FOR LARGE/BIG BOOKINGS)
    @existing_diners_number = @existing_bookings.pluck(:number_of_diners)  
    @lunch_existing_diners_number = @lunch_existing_bookings.pluck(:number_of_diners)
    @eve_existing_diners_number = @eve_existing_bookings.pluck(:number_of_diners)
    
    # EXISTING TABLES OF 9, 10, 11 OR 12) IN THE DAY COUNT
    @day_big_tables_count = (@existing_diners_number.count(9)+ @existing_diners_number.count(10)+ @existing_diners_number.count(11)+ @existing_diners_number.count(12))
    @lunch_big_tables_count = (@lunch_existing_diners_number.count(9)+ @lunch_existing_diners_number.count(10)+ @lunch_existing_diners_number.count(11)+ @lunch_existing_diners_number.count(12))
    @eve_big_tables_count = (@eve_existing_diners_number.count(9)+ @eve_existing_diners_number.count(10)+ @eve_existing_diners_number.count(11)+ @eve_existing_diners_number.count(12))

    # EXISTING TABLES OF 7 OR 8) IN THE DAY COUNT
    @day_large_tables_count = (@existing_diners_number.count(8))+ (@existing_diners_number.count(7))
    @lunch_large_tables_count = (@lunch_existing_diners_number.count(8))+ (@lunch_existing_diners_number.count(7))
    @eve_large_tables_count = (@eve_existing_diners_number.count(8))+ (@eve_existing_diners_number.count(7))
    
    # TOTAL EXISTING TABLES OVER 6, (7-12) IN THE DAY COUNT
    @day_total_over_six_count = (@day_big_tables_count + @day_large_tables_count)
    @lunch_total_over_six_count = (@lunch_big_tables_count + @lunch_large_tables_count)
    @eve_total_over_six_count = (@eve_big_tables_count + @eve_large_tables_count)
    
    # GET BIG AND LARGE TABLE MAX FROM SYSTEM PARAMETERS
    restaurant_id= 1
    @big_table_max = Rdetail.get_value(restaurant_id, "big_table_count") 
    @large_table_max = Rdetail.get_value(restaurant_id, "large_table_count") 
   
    hash_of_times = Booking.get_times_hash(booking_datetime.to_datetime.wday)
    hash_to_delete = Array.new # this will be used to gather times to be deleted
    
    #B5 Exemptions part 2 - extra code Nov 2019 to enable distinction between whole and half day exemptions
   
    part_exempt_days_hash = Exemption.where("exempt_day >= ?",Date.today).where.not("lunch = ? AND dinner= ?", true , true)
   
    if part_exempt_days_hash.count > 0
       part_exempt_days_hash.each do |part_exemption|
          if booking_datetime.to_date == part_exemption.exempt_day.to_date
             if part_exemption.lunch == true
                hash_to_delete <<["12:00"]
                hash_to_delete <<["12:30"]
                hash_to_delete <<["13:00"]
                hash_to_delete <<["13:30"]
                hash_to_delete <<["14:00"]
                hash_to_delete <<["14:30"]
                hash_to_delete <<["15:00"]
                hash_to_delete <<["15:30"]
             elsif part_exemption.dinner == true
               hash_to_delete <<["17:00"]
               hash_to_delete <<["17:30"]
               hash_to_delete <<["18:00"]
               hash_to_delete <<["18:30"]
               hash_to_delete <<["19:00"]
               hash_to_delete <<["19:30"]
               hash_to_delete <<["20:00"]
               hash_to_delete <<["20:30"]
               hash_to_delete <<["21:00"]
            end    # end if
          end # end if
       end  # end do
     else 
    end  
   
    # LARGE TABLES ARE ONLY ALLOWED TO BOOK AT CERTAIN TIMES - Changes from Shauna email 7/11/18
    if number_of_diners >= 7
      if ([3,4,5,6].include? (booking_datetime.to_date.wday))
        hash_of_times.pop
        hash_of_times.delete(["17:30"])
        hash_of_times.delete(["18:00"])
        hash_of_times.delete(["18:30"])
        hash_of_times.delete(["19:00"])
        hash_of_times.delete(["19:30"])
      end
      if ([5,6].include? (booking_datetime.to_date.wday))
        hash_of_times.delete(["13:00"])
        hash_of_times.delete(["13:30"])
        hash_of_times.delete(["14:00"])
        hash_of_times.delete(["14:30"])
      end  
      if ([0].include? (booking_datetime.to_date.wday))
        hash_of_times.delete(["12:30"])
        hash_of_times.delete(["13:00"])
        hash_of_times.delete(["13:30"])
        hash_of_times.delete(["14:00"])
        hash_of_times.delete(["15:00"])
        hash_of_times.delete(["15:30"])
      end   
      #new conditions to rid array of times if current clashing large groups
      if  (([5,6].include? (booking_datetime.to_date.wday))&&(@lunch_total_over_six_count>=2))
        hash_of_times.delete(["12:00"])
        hash_of_times.delete(["12:30"])
        hash_of_times.delete(["13:00"])
        hash_of_times.delete(["13:30"])
        hash_of_times.delete(["14:00"])
        hash_of_times.delete(["14:30"])
      end
      if  (([5,6].include? (booking_datetime.to_date.wday))&&(@eve_total_over_six_count>=2))
        hash_of_times.delete(["17:00"])
        hash_of_times.delete(["17:30"])
        hash_of_times.delete(["18:00"])
        hash_of_times.delete(["18:30"])
        hash_of_times.delete(["19:00"])
        hash_of_times.delete(["19:30"])
        hash_of_times.delete(["20:00"])
        hash_of_times.delete(["20:30"])
        hash_of_times.delete(["21:00"])
      end
    end
      
    if number_of_diners >= 9
      if  (([5,6].include? (booking_datetime.to_date.wday))&&(@lunch_big_tables_count >= @big_table_max))
        hash_of_times.delete(["12:00"])
        hash_of_times.delete(["12:30"])
        hash_of_times.delete(["13:00"])
        hash_of_times.delete(["13:30"])
        hash_of_times.delete(["14:00"])
        hash_of_times.delete(["14:30"])
      end
      if  (([5,6].include? (booking_datetime.to_date.wday))&&(@eve_big_tables_count >= @big_table_max))
        hash_of_times.delete(["17:00"])
        hash_of_times.delete(["17:30"])
        hash_of_times.delete(["18:00"])
        hash_of_times.delete(["18:30"])
        hash_of_times.delete(["19:00"])
        hash_of_times.delete(["19:30"])
        hash_of_times.delete(["20:00"])
        hash_of_times.delete(["20:30"])
        hash_of_times.delete(["21:00"])
      end
    end
     
      if @existing_bookings.count == 0
        return (hash_of_times - hash_to_delete) # this line amended to remove has_to_delete values for exemptions
      else
        hash_of_times.each do |time|
          booking = @existing_bookings.first.booking_date_time.change({ hour: time[0][0,2], min: time[0][3,5] })
       
          # code for adding more diners at 5 and 5.30 on wed and thurs, uses new param on rdetails
          if ([3,4].include? (booking_datetime.to_date.wday))
            if [["17:00"]].include? (time)
             @max_diners_at_current_time = Rdetail.get_value(1, "wed_thurs_eve_max_diners") 
        # Rails.logger.debug("1700_BOOKING_LOGING_diners_at_same_start_time : #{@max_diners_at_current_time}")
        # Rails.logger.debug("432_BOOKING_L : #{time.inspect}")
            elsif [["17:30"]].include? (time)
             @max_diners_at_current_time = Rdetail.get_value(1, "wed_thurs_eve_max_diners")-2 
        # Rails.logger.debug("1730_BOOKING_LOGING_diners_at_same_start_time : #{@max_diners_at_current_time}")
        # Rails.logger.debug("436_BOOKING_L : #{time.inspect}")
            else
             @max_diners_at_current_time = Rdetail.get_value(1, "max_diners_at_current_time") 
        # Rails.logger.debug("423_BOOKING_LOGING_diners_at_same_start_time : #{@max_diners_at_current_time}")
        # Rails.logger.debug("424_BOOKING_L : #{time.inspect}")
            end
          end
          
          #NEW CODE 7/JAN/2019 - allow up to 14 at each time period on sunday
          if ([0].include? (booking_datetime.to_date.wday))
           @max_diners_at_current_time = Rdetail.get_value(1, "sun_max_diners") 
         end
         
          # code for adding more diners at friday lunch time, uses new param on rdetails
          if ([5].include? (booking_datetime.to_date.wday))
            if [["12:00"],["12:30"],["13:00"],["13:30"]].include? (time)
             @max_diners_at_current_time = Rdetail.get_value(1, "max_fri_lunch_diners") 
            else
             @max_diners_at_current_time = Rdetail.get_value(1, "max_diners_at_current_time") 
            end
          end
         
             
        if (@max_diners_at_current_time- get_total_diners_for_current_time(booking)) <= 0
            hash_to_delete <<time 
          elsif (@max_diners_at_current_time- get_total_diners_for_current_time(booking)) < number_of_diners
            hash_to_delete <<time
          else
        #there must be space to accomodate the party so leave this time intact 
          end  
        end
        
       if hash_of_times.empty?
         return Error.get_msg("999999118") 
       elsif hash_to_delete.empty?
         return hash_of_times
       else
          return (hash_of_times - hash_to_delete)
       end
    end
  end
  
  def self.get_times_hash(day_of_week)
    case day_of_week
    when 0 #Sunday
      hash_of_times = Hash.new
      hash_of_times=[["12:00"],["12:30"],["13:00"],["13:30"],["14:00"],["14:30"],["15:00"],["15:30"]]
    when 3 #Wednesday
      hash_of_times = Hash.new
      hash_of_times=[["17:00"],["17:30"],["18:00"],["18:30"],["19:00"],["19:30"],["20:00"],["20:30"],["21:00"]]  
    when 4 #Thursday
      hash_of_times = Hash.new
      hash_of_times=[["17:00"],["17:30"],["18:00"],["18:30"],["19:00"],["19:30"],["20:00"],["20:30"],["21:00"]]  
    when 5 #Friday
      hash_of_times = Hash.new
      hash_of_times= [["12:00"],["12:30"],["13:00"],["13:30"],["14:00"],["14:30"],["17:00"],["17:30"],["18:00"],["18:30"],["19:00"],["19:30"],["20:00"],["20:30"],["21:00"]]   
    when 6 #Saturday
      hash_of_times = Hash.new
      hash_of_times=[["12:00"],["12:30"],["13:00"],["13:30"],["14:00"],["14:30"],["17:00"],["17:30"],["18:00"],["18:30"],["19:00"],["19:30"],["20:00"],["20:30"],["21:00"]]
   end
   
   
 end
 
 # TOTAL DINERS COUNT FOR CURRENT TIME (no of diners arriving at this moment+15 mins to start reservation)
  # this function is a duplicate of that used on the staff booking by day pages - 3 variants midweek, fri/sat, sunday
  def self.get_total_diners_for_current_time(date_and_time)
  @diners_at_same_start_time = 0
  @bookings_at_same_start_time = []

  @bookings_at_same_start_time = Booking.where("booking_date_time BETWEEN ? AND ?", date_and_time,(date_and_time+15.minutes)).where(:status => "Confirmed")
  @diners_at_same_start_time = @bookings_at_same_start_time.to_a.sum do |booking_at_same_start_time|
          booking_at_same_start_time.number_of_diners
        end
        return @diners_at_same_start_time
  end
  
  #This function will check everything to decide if a large or big table booking can take place, based on a booking request that includes a date.
  def self.check_for_big_tables_params(params)
   # GET ALL EXISTING BOOKINGS FOR THE DAY
    booking_datetime = (params[:booking_date].to_datetime)
    number_of_diners = (params[:number_of_diners].to_i)
    
     if ([7,8,9,10,11,12].include? number_of_diners)
    
    @existing_bookings = Booking.where("booking_date_time BETWEEN ? AND ?", booking_datetime.beginning_of_day, booking_datetime.end_of_day).where(:status => "Confirmed")
    #restaurant_id = @existing_bookings.first.restaurant_id
    restaurant_id = Restaurant.first.id
    @max_diners_at_current_time = Rdetail.get_value(restaurant_id, "max_diners_at_current_time")
    @big_table_max = Rdetail.get_value(restaurant_id, "big_table_count") 
    @large_table_max = Rdetail.get_value(restaurant_id, "large_table_count") 
    
    @lunch_existing_bookings = Booking.where("booking_date_time BETWEEN ? AND ?", booking_datetime.beginning_of_day, booking_datetime.change({ hour: 16, min: 55 })).where(:status => "Confirmed")
    @eve_existing_bookings = Booking.where("booking_date_time BETWEEN ? AND ?", booking_datetime.change({ hour: 17, min: 00 }), booking_datetime.end_of_day).where(:status => "Confirmed")
    
    # HASH OF EXISTING DINERS NUMBER (USED ONLY FOR LARGE/BIG BOOKINGS)
    @existing_diners_number = @existing_bookings.pluck(:number_of_diners)  
    @lunch_existing_diners_number = @lunch_existing_bookings.pluck(:number_of_diners)
    @eve_existing_diners_number = @eve_existing_bookings.pluck(:number_of_diners)
    
    # EXISTING TABLES OF 9, 10, 11 OR 12) IN THE DAY COUNT
    @day_big_tables_count = (@existing_diners_number.count(9)+ @existing_diners_number.count(10)+ @existing_diners_number.count(11)+ @existing_diners_number.count(12))
    @lunch_big_tables_count = (@lunch_existing_diners_number.count(9)+ @lunch_existing_diners_number.count(10)+ @lunch_existing_diners_number.count(11)+ @lunch_existing_diners_number.count(12))
    @eve_big_tables_count = (@eve_existing_diners_number.count(9)+ @eve_existing_diners_number.count(10)+ @eve_existing_diners_number.count(11)+ @eve_existing_diners_number.count(12))

    # EXISTING TABLES OF 7 OR 8) IN THE DAY COUNT
    @day_large_tables_count = (@existing_diners_number.count(8))+ (@existing_diners_number.count(7))
    @lunch_large_tables_count = (@lunch_existing_diners_number.count(8))+ (@lunch_existing_diners_number.count(7))
    # Rails.logger.debug("xxxxx_@lunch_large_tables_count : #{@lunch_large_tables_count.inspect}")
    @eve_large_tables_count = (@eve_existing_diners_number.count(8))+ (@eve_existing_diners_number.count(7))
    # Rails.logger.debug("xxxxx_@eve_large_tables_count : #{@eve_large_tables_count.inspect}")
    
    # TOTAL EXISTING TABLES OVER 6, (7-12) IN THE DAY COUNT
    @day_total_over_six_count = (@day_big_tables_count + @day_large_tables_count)
    @lunch_total_over_six_count = (@lunch_big_tables_count + @lunch_large_tables_count)
    # Rails.logger.debug("in @lunch_total_over_six_count: #{@lunch_total_over_six_count.inspect}")
    @eve_total_over_six_count = (@eve_big_tables_count + @eve_large_tables_count)
    
    #NEW STATMENT ADDED JAN 2017, can only be 2 tables over 6 in any session, but can only be 2  at 7 or 8 or 1 large and 1 at 7 or 8 , not 2 at over 8

    if (([0,3,4].include? (params[:booking_date]).to_date.wday) && (@day_total_over_six_count < 2)) 
    
      #VAILDATIONS for non-lunch days
      if (([7,8].include? number_of_diners) && (@day_large_tables_count >= @large_table_max))
           return Error.get_msg("999999108")  
      end
       
      if (([9,10,11,12].include? number_of_diners) && (@day_big_tables_count >= @big_table_max))
           return Error.get_msg("999999107")  
      end
       
    elsif ([5,6].include? (params[:booking_date]).to_date.wday)   
     
      #VAILDATIONS for days with lunch session
      if ((([7,8].include? number_of_diners) && (@lunch_total_over_six_count >= @large_table_max)) && (([7,8].include? number_of_diners) && (@eve_total_over_six_count >= @large_table_max)))
           return Error.get_msg("999999108")  
      end
      
      if ((([9,10,11,12].include? number_of_diners) && (@lunch_big_tables_count >= @big_table_max))&&(([9,10,11,12].include? number_of_diners) && (@eve_big_tables_count >= @big_table_max)))
           return Error.get_msg("999999107")  
      end
   else
     #Rails.logger.debug("in @fail over else : #{}")
     
     return Error.get_msg("999999107") 
   end
 
   else #this is the else and end for checking the diners count is over 6
   end
 end
 
 def self.deposit_amount(params)
   @deposit_table_size =  (Rdetail.deposit_table_size.to_i)
   @booking = params
     deposit_due = (@booking.number_of_diners*10)
     deposit_paid = @booking.deposit_amount
   
   if @booking.number_of_diners < @deposit_table_size
      return "No Deposit Required", 0
   elsif !@booking.deposit_amount.present?
     return "Deposit Due", deposit_due
   elsif deposit_due == deposit_paid || deposit_due < deposit_paid
     return "Paid in Full", 0
   elsif deposit_due > deposit_paid
      return "Outstanding Balance", deposit_due-deposit_paid
   else 
   end
 end
end
